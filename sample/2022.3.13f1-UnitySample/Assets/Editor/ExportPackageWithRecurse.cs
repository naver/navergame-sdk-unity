using UnityEngine;
using UnityEditor;

public class ExportPackageWithRecurse
{
    [MenuItem("Assets/Export Package with Recurse")]
    static void Export()
    {
        // 내보낼 경로와 파일 이름 설정
        string exportPath = EditorUtility.SaveFilePanel(
            "Export Unity Package", 
            "", 
            "NNGExportPackage.unitypackage", 
            "unitypackage"
        );

        if (string.IsNullOrEmpty(exportPath))
            return;

        // 선택한 파일이나 폴더의 경로 가져오기
        string[] assetPaths = Selection.assetGUIDs;

        // 경로를 문자열 배열로 변환
        for (int i = 0; i < assetPaths.Length; i++)
        {
            assetPaths[i] = AssetDatabase.GUIDToAssetPath(assetPaths[i]);
        }

        // 패키지 내보내기 (재귀 옵션 사용)
        AssetDatabase.ExportPackage(assetPaths, exportPath, ExportPackageOptions.Recurse);

        // 완료 메시지
        Debug.Log("패키지 내보내기 완료: " + exportPath);
    }
}
