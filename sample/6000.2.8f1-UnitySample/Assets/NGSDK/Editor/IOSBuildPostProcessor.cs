#if UNITY_IOS
using UnityEditor;
using UnityEditor.Callbacks;
using UnityEditor.iOS.Xcode;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;
using UnityEngine;
using UnityEngine.Assertions;

public class IOSBuildPostProcessor
{
    // Unity 프로젝트 내 원본 xcframework 루트 경로
    private static readonly string SrcRoot = Path.Combine(Application.dataPath, "NGSDK", "Plugins", "iOS");

    // Xcode 빌드 폴더 내 복사 대상 루트 경로 (빌드폴더/Frameworks/NGSDK/Plugins/iOS)
    private const string DestRelativeRoot = "Frameworks/NGSDK/Plugins/iOS";

    [PostProcessBuild]
    public static void OnPostProcessBuild(BuildTarget target, string buildPath)
    {
        if (target != BuildTarget.iOS)
            return;

        string destRootFullPath = Path.Combine(buildPath, DestRelativeRoot);

        if (!Directory.Exists(SrcRoot))
        {
            return;
        }

        // 복사 대상 루트 폴더가 있으면 삭제 후 재복사
        if (Directory.Exists(destRootFullPath))
        {
            Directory.Delete(destRootFullPath, true);
        }

        Directory.CreateDirectory(destRootFullPath);

        // SrcRoot 내 모든 .xcframework 폴더를 찾아서 통째 복사
        var xcframeworkDirs = Directory.GetDirectories(SrcRoot, "*.xcframework");

        if (xcframeworkDirs.Length == 0)
        {
            return;
        }

        string pbxProjectPath = PBXProject.GetPBXProjectPath(buildPath);
        PBXProject pbxProject = new PBXProject();
        pbxProject.ReadFromFile(pbxProjectPath);

        string mainTargetGuid = pbxProject.GetUnityMainTargetGuid();
        string copyFilesPhase = pbxProject.GetCopyFilesBuildPhaseByTarget(mainTargetGuid, "Embed Frameworks", "", "10");

        foreach (var xcframeworkDir in xcframeworkDirs)
        {
            string frameworkName = Path.GetFileName(xcframeworkDir);
            string destFrameworkPath = Path.Combine(destRootFullPath, frameworkName);

            CopyDirectory(xcframeworkDir, destFrameworkPath);

            string fileGuid = pbxProject.AddFile(destFrameworkPath, DestRelativeRoot + "/" + frameworkName);
            pbxProject.AddFileToBuildSection(mainTargetGuid, copyFilesPhase, fileGuid);
        }

        pbxProject.WriteToFile(pbxProjectPath);

        foreach (string xcframeworkDir in xcframeworkDirs)
        {
            string contents = File.ReadAllText(pbxProjectPath);
            string frameworkName = Path.GetFileName(xcframeworkDir);
            string pattern = "(?<=Embed Frameworks)(?:.*)(\\/\\* " + frameworkName + "\\ \\*\\/)(?=; };)";
            string oldText = "/* " + frameworkName + " */";
            string updatedText = "/* " + frameworkName + " */; settings = {ATTRIBUTES = (CodeSignOnCopy,RemoveHeadersOnCopy, ); }";
            contents = Regex.Replace(contents, pattern, m => m.Value.Replace(oldText, updatedText));
            File.WriteAllText(pbxProjectPath, contents);
        }
    }

    private static void CopyDirectory(string sourcePath, string destPath)
    {
        Assert.IsFalse(Directory.Exists(destPath));
        Directory.CreateDirectory(destPath);

        foreach (string file in Directory.GetFiles(sourcePath))
            File.Copy(file, Path.Combine(destPath, Path.GetFileName(file)));

        foreach (string dir in Directory.GetDirectories(sourcePath))
            CopyDirectory(dir, Path.Combine(destPath, Path.GetFileName(dir)));
    }
}
#endif
