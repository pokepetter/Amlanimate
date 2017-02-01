import UnityEngine
import UnityEngine.UI
import System.Collections

class AutoButton (MonoBehaviour): 
    
    public buttonName as Text
    public hotKey as Text


    def Awake():
        words = gameObject.name.Split(char('['))

        buttonName.text = words[0]
        if words.Length > 0:
            hotKey.text = words[1]

        Commands.Run(words[0])