import UnityEngine

class DraggableWindow (MonoBehaviour, IDragHandler): 

    public targetWindow as Transform

    def OnDrag(eventData as PointerEventData):
        targetWindow.position = eventData.position
