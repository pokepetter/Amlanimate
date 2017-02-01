using UnityEditor;
 
public class CustomHotkeys {
 
    //CTRL+D to duplicate
    [MenuItem("Edit/Custom/Duplicate %d")]
    static void Duplicate () {
        EditorApplication.ExecuteMenuItem("Edit/Duplicate");
    }
}