import UnityEngine
import UnityEngine.UI

class SaveWindow (MonoBehaviour): 

#    public saveWindow as GameObject
    public saveLocation as string
    public inputField as Text
#    public
    private newScale as Vector3

    def OpenSaveWindow():
        gameObject.SetActive(true)
        
#        if inputField.text.Length == 0:
#            print(inputField.text.Length)
#            inputField.text = "C:/Animations/UntitledProject" as string
#            saveLocation = "C:/Animations/UntitledProject"
#        else:
        inputField.text = saveLocation
        
        transform.localScale = Vector3.zero
        newScale = Vector3.one /2
        
    def CloseSaveWindow():
        newScale = Vector3.zero
        
    def Update():
        transform.localScale = Vector3.Lerp(transform.localScale, newScale, Time.deltaTime * 15)
        saveLocation = inputField.text