using UnityEditor;
using UnityEngine;
using System.Collections;

public class ReplaceWithPrefab : EditorWindow {

    public GameObject prefab;

    [MenuItem("Custom/ReplaceWithPrefab")]
    static void ShowWindow() {
        EditorWindow.GetWindow<ReplaceWithPrefab>();
    }

    void Replace() {
        if (prefab == null) {
            Debug.Log("No prefab! Can't replace!");
            return;
        }

        Transform[] selected = Selection.transforms;

        for (int i = 0; i < selected.Length; i++) {
            Transform transform = selected[i];

            Vector3 position = transform.position;
            Quaternion rotation = transform.rotation;
            Vector3 localScale = transform.localScale;
            Transform parent = transform.parent;

            Undo.DestroyObjectImmediate(transform.gameObject);

            GameObject instance = PrefabUtility.InstantiatePrefab(prefab) as GameObject;
            Undo.RegisterCreatedObjectUndo(instance, "Undo replace");

            Transform instanceTrans = instance.transform;
            instanceTrans.parent = parent;
            instanceTrans.position = position;
            instanceTrans.rotation = rotation;
            instanceTrans.localScale = localScale;

            EditorUtility.SetDirty(instance);

        }
    }

    void OnGUI() {
        if (GUILayout.Button("Replace", GUILayout.Height(30)))
            Replace();

        GUILayout.Label("Prefab:");
        prefab = (GameObject) EditorGUILayout.ObjectField("", prefab, typeof(GameObject), true);


    }

}
