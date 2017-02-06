import UnityEngine
import UnityEngine.UI
import System.Collections

class PaletteButton (MonoBehaviour): 

    private button as Button
    private colorAsStrings as (string)


    def Awake():
        button = GetComponent(Button)
        button.onClick.AddListener({Click()})

        color = transform.GetComponent(Image).color
        colorAsStrings = (color.r.ToString(), color.g.ToString(), color.b.ToString(), color.a.ToString()) 

    def Click():
        Commands.Run("SelectColor", colorAsStrings)  