#if UNITY_IOS
using UnityEditor;
using UnityEditor.Callbacks;
using System.IO;
using UnityEngine;

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

        foreach (var xcframeworkDir in xcframeworkDirs)
        {
            string frameworkName = Path.GetFileName(xcframeworkDir);
            string destFrameworkPath = Path.Combine(destRootFullPath, frameworkName);

            CopyDirectory(xcframeworkDir, destFrameworkPath);
        }
    }
 
    private static void CopyDirectory(string sourceDir, string targetDir)
    {
        Directory.CreateDirectory(targetDir);

        foreach (var file in Directory.GetFiles(sourceDir))
        {
            string destFile = Path.Combine(targetDir, Path.GetFileName(file));
            File.Copy(file, destFile, true);
        }

        foreach (var directory in Directory.GetDirectories(sourceDir))
        {
            string destSubDir = Path.Combine(targetDir, Path.GetFileName(directory));
            CopyDirectory(directory, destSubDir);
        }
    }
}
#endif
