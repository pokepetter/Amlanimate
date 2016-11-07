import UnityEngine
import UnityEngine.UI
import UnityEngine.EventSystems

class FrameParent (MonoBehaviour, IPointerClickHandler ): 

    public menu as GameObject
    private localCursorPosition as Vector2

    def OnPointerClick(eventData as PointerEventData):
        if (eventData.button == PointerEventData.InputButton.Right
            and RectTransformUtility.ScreenPointToLocalPointInRectangle(GetComponent(RectTransform), eventData.position, eventData.pressEventCamera, localCursorPosition)
            ):
            localCursorPosition = Vector2(Mathf.FloorToInt(localCursorPosition.x), Mathf.FloorToInt(localCursorPosition.y))
            menu.transform.localPosition.x = localCursorPosition.x +2
            menu.SetActive(true)