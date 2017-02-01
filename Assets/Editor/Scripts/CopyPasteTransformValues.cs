using UnityEditor;
using UnityEngine;
using System.Collections;

public class CopyPasteTransformValues : EditorWindow {

	private Vector3[] posArr;
	private Quaternion[] rotArr;
	private Vector3[] scaleArr;

	
	private bool copyPosition = true;
	private bool copyRotation = true;
	private bool copyScale= true;
	
	private Transform[] transformArr;

    [MenuItem("Custom/CopyPasteTransformValues")]
    static void ShowWindow() {
        EditorWindow.GetWindow<CopyPasteTransformValues>();
    }

    private void Copy() {
		 if (copyPosition) {
			posArr = new Vector3[Selection.transforms.Length];
		 }
		 if (copyRotation) {
			rotArr = new Quaternion[Selection.transforms.Length];
		 }
		 if (copyScale) {
			scaleArr = new Vector3[Selection.transforms.Length];
		 }
		 
		 for (int i = 0; i < Selection.transforms.Length; i++) {
			if (copyPosition) {
				 posArr[i] = Selection.transforms[i].localPosition;
			}
			if (copyRotation) {
				 rotArr[i] = Selection.transforms[i].localRotation;
			}
			if (copyScale) {
				 scaleArr[i] = Selection.transforms[i].localScale;
			}
		 }
    }
	
    private void Paste() {
       for (int i = 0; i < Selection.transforms.Length; i++) {
			Undo.RecordObject(Selection.transforms[i], "Undo Paste Transform Values");

			if (copyPosition) {
				Selection.transforms[i].localPosition = posArr[i];
			}
			if (copyRotation) {
				Selection.transforms[i].localRotation = rotArr[i];
			}
			if (copyScale) {
				Selection.transforms[i].localScale = scaleArr[i];
			}
			
			EditorUtility.SetDirty(Selection.transforms[i]);
		}
    }

    void OnGUI() {
		EditorGUILayout.BeginHorizontal(); {

        if (GUILayout.Button("Copy", GUILayout.Height(30)))
            Copy();
		
		if (GUILayout.Button("Paste", GUILayout.Height(30)))
            Paste();
		} EditorGUILayout.EndHorizontal();

		
        EditorGUILayout.BeginHorizontal(); {
        GUILayout.Label("Position:");
            copyPosition = GUILayout.Toggle(copyPosition, "");
        } EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal(); {
        GUILayout.Label("Rotation:");
            copyRotation = GUILayout.Toggle(copyRotation, "");
        } EditorGUILayout.EndHorizontal();
		
        EditorGUILayout.BeginHorizontal(); {
        GUILayout.Label("Scale:");
            copyScale = GUILayout.Toggle(copyScale, "");
        } EditorGUILayout.EndHorizontal();
		
    }

}
