using UnityEditor;
using UnityEngine;
using System.Collections;

public class RandomizeSelected : EditorWindow {

    private Transform[] selectedObjects;

    private bool rotX, rotY, rotZ;
    private bool scaleX, scaleY, scaleZ;

    public float minScaleFactor, maxScaleFactor;

    private string scaleLabel;
    private float textFieldInt;

    [MenuItem("Custom/Randomizer")]
    static void ShowWindow() {
        EditorWindow.GetWindow<RandomizeSelected>();
    }

    private void Randomize() {
//        Debug.Log("R-R-Randomize!");
        Transform[] transformArr = Selection.transforms;
        for (int i = 0; i < transformArr.Length; i++) {
            Transform transform = transformArr[i];

            Undo.RecordObject(transform, "Undo randomization");

            Vector3 oldEulerAngles = transform.localEulerAngles;
            transform.localEulerAngles = new Vector3(
                rotX ? Random.Range(0f, 360f) : oldEulerAngles.x,
                rotY ? Random.Range(0f, 360f) : oldEulerAngles.y,
                rotZ ? Random.Range(0f, 360f) : oldEulerAngles.z
            );

            Vector3 oldLocalScale = transform.localScale;
            transform.localScale = new Vector3(
                scaleX ? Random.Range(minScaleFactor, maxScaleFactor) : oldLocalScale.x,
                scaleY ? Random.Range(minScaleFactor, maxScaleFactor) : oldLocalScale.y,
                scaleZ ? Random.Range(minScaleFactor, maxScaleFactor) : oldLocalScale.z
            );

            EditorUtility.SetDirty(transform);
        }
    }

    void OnGUI() {
        if (GUILayout.Button("Randomize", GUILayout.Height(30)))
            Randomize();

        GUILayout.Label("Rotation");

        EditorGUILayout.BeginHorizontal(); {
            rotX = GUILayout.Toggle(rotX, "X");
            rotY = GUILayout.Toggle(rotY, "Y");
            rotZ = GUILayout.Toggle(rotZ, "Z");
        } EditorGUILayout.EndHorizontal();

        GUILayout.Label("Scale");

        EditorGUILayout.BeginHorizontal(); {
            scaleX = GUILayout.Toggle(scaleX, "X");
            scaleY = GUILayout.Toggle(scaleY, "Y");
            scaleZ = GUILayout.Toggle(scaleZ, "Z");
        } EditorGUILayout.EndHorizontal();

        GUILayout.Label("Scale Factor");

        EditorGUILayout.BeginHorizontal(); {
            minScaleFactor = EditorGUILayout.FloatField(minScaleFactor);
            GUILayout.Label("- ");
            maxScaleFactor = EditorGUILayout.FloatField(maxScaleFactor);
        } EditorGUILayout.EndHorizontal();
    }

}
