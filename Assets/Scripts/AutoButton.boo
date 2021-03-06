﻿import UnityEngine
import UnityEngine.UI
import System.Collections

class AutoButton (MonoBehaviour): 
    
    public buttonText as Text
    public hotKeyText as Text

    [Space(10)]
    public argumentInputs as (Text)

    [Space(10)]
    public hotKey as string
    public commandToRun as string

    private keys as (string)
    private alphaNumericKey as KeyCode
    private requireCtrl as bool
    private requireAlt as bool
    private requireShift as bool

    private button as Button


    def Awake():
        button = GetComponent(Button)
        button.onClick.AddListener({Click()})

        words = gameObject.name.Split(char('['))

        commandToRun = words[0]
        buttonText.text = commandToRun
        if words.Length > 1:
            for i in range(words.Length-1):
                hotKeyText.text += words[i+1]
            
            hotKey = gameObject.name.Substring(commandToRun.Length+1)


        modKeys = List of KeyCode()

        keys = hotKey.Split(char('+'))
        for key in keys:
            if key == "Ctrl":
                requireCtrl = true
            if key == "Alt":
                requireAlt = true
            if key == "Shift":
                requireShift = true
            if key.Length == 1:
                alphaNumericKey = System.Enum.Parse(KeyCode, key)


    def Update():
        if keys.Length == 2:
            if requireCtrl:
                if Input.GetKey(KeyCode.LeftControl) or Input.GetKey(KeyCode.RightControl):
                    if Input.GetKeyDown(alphaNumericKey):
                        Click()

            if requireAlt:
                if Input.GetKey(KeyCode.LeftAlt) or Input.GetKey(KeyCode.RightAlt):
                    if Input.GetKeyDown(alphaNumericKey):
                        Click()

            if requireShift:
                if Input.GetKey(KeyCode.LeftShift) or Input.GetKey(KeyCode.RightShift):
                    if Input.GetKeyDown(alphaNumericKey):
                        Click()


        if keys.Length == 3:
            if requireCtrl:
                if Input.GetKey(KeyCode.LeftControl) or Input.GetKey(KeyCode.RightControl):

                    if requireAlt:
                        if Input.GetKey(KeyCode.LeftAlt) or Input.GetKey(KeyCode.RightAlt):
                            if Input.GetKeyDown(alphaNumericKey):
                                Click()

                    if requireShift:
                        if Input.GetKey(KeyCode.LeftShift) or Input.GetKey(KeyCode.RightShift):
                            if Input.GetKeyDown(alphaNumericKey):
                                Click()

            if requireAlt:
                if Input.GetKey(KeyCode.LeftAlt) or Input.GetKey(KeyCode.RightAlt):
                    if requireShift:
                        if Input.GetKey(KeyCode.LeftShift) or Input.GetKey(KeyCode.RightShift):
                            if Input.GetKeyDown(alphaNumericKey):
                                Click()

    def Click():
        parameters = array(string, argumentInputs.Length)
        for i in range(argumentInputs.Length):
            parameters[i] = argumentInputs[i].text

        Commands.Run(commandToRun, parameters)