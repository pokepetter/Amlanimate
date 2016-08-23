import UnityEngine
import UnityEngine.UI
import UnityEngine.EventSystems

class IndicatorBar (MonoBehaviour, IPointerDownHandler, IDragHandler): 

    public indicator as Indicator
    private localCursorPosition as Vector2

    def OnPointerDown(eventData as PointerEventData):
        if RectTransformUtility.ScreenPointToLocalPointInRectangle(GetComponent(RectTransform), eventData.position, eventData.pressEventCamera, localCursorPosition):
            localCursorPosition = Vector2(Mathf.FloorToInt(localCursorPosition.x), Mathf.FloorToInt(localCursorPosition.y))
        indicator.GoToFrame(localCursorPosition.x)

    def OnDrag(eventData as PointerEventData):
        if RectTransformUtility.ScreenPointToLocalPointInRectangle(GetComponent(RectTransform), eventData.position, eventData.pressEventCamera, localCursorPosition):
            localCursorPosition = Vector2(Mathf.Clamp(Mathf.FloorToInt(localCursorPosition.x), 0, 100), Mathf.FloorToInt(localCursorPosition.y))
        indicator.GoToFrame(localCursorPosition.x)