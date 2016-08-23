import UnityEngine

class FollowMouse (MonoBehaviour): 

    public mcamera as Camera

    def Update ():
        p as Vector3 = mcamera.ScreenToWorldPoint(Vector3(Input.mousePosition.x, Input.mousePosition.y, (mcamera.transform.position.z * -0.1f)))
        transform.position = p