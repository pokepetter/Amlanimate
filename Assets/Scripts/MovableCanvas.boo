import UnityEngine
import UnityEngine.UI

class MovableCanvas (MonoBehaviour): 

    public scrollRect as ScrollRect

    def Update():
        if Input.GetKeyDown(KeyCode.Space):
            scrollRect.horizontal = true
            scrollRect.vertical = true
        if Input.GetKeyUp(KeyCode.Space):
            scrollRect.horizontal = false
            scrollRect.vertical = false