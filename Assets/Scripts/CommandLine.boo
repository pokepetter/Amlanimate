import UnityEngine
import UnityEngine.UI

class CommandLine (MonoBehaviour): 
    
    public toggledGraphic as Transform
    public panel as Image
    public text as Text
    public hotkeyText as Text
    
    public methodNameToRun as string
    public arguments as List of string
    public debugArgs as (string)
    public argumentIndex as int

    public canvas as Transform

    private availableMethods as List of string
    private allButtons as (AutoButton)

    public commandCompleted as bool
    public currentArgument as string
    private isOpen as bool
    public targetScale as Vector2
    private elapsedTime as single
    private t as single


    def Start():
        availableMethods = Commands.GetMethodNames()
        allButtons = canvas.GetComponentsInChildren[of AutoButton]()
        arguments = List of string()
        argumentIndex = -1


    def Update():
        if Input.GetKey(KeyCode.LeftControl):
            if Input.GetKeyDown(KeyCode.F):
                print("search")
                Toggle()

            if Input.GetKeyDown(KeyCode.Backspace):
                methodNameToRun = ""
                text.text = ""
                arguments.Clear()
                argumentIndex = -1

        if isOpen:
            if Input.anyKeyDown:
                if isOpen and Input.inputString.Length == 1:
                    inputChar = Convert.ToChar(Input.inputString)

                    if not commandCompleted:
                        if char.IsLetter(inputChar):
                            methodNameToRun += Input.inputString
                            text.text = methodNameToRun

                    else:
                        if Input.inputString == " ":
                            text.text += " "
                            //start argument
                            arguments.Add("")
                            argumentIndex++

                        if char.IsNumber(inputChar) or char.IsLetter(inputChar):
                            arguments[argumentIndex] += inputChar
                            debugArgs = array(arguments)
                            text.text += inputChar

                for method in availableMethods:
                    if method == methodNameToRun:
                        commandCompleted = true
                        panel.color = Color(0.6, 0.8, 0.2)
                        for button in allButtons:
                            if methodNameToRun == button.commandToRun:
                                hotkeyText.text = button.hotKey
                                break
                        break
                    else:
                        commandCompleted = false
                        panel.color = Color.white

            if Input.GetKeyDown(KeyCode.Backspace):
                print("backspace")
                if methodNameToRun.Length > 0 and not commandCompleted:
                    methodNameToRun = methodNameToRun.TrimEnd(methodNameToRun[methodNameToRun.Length -1])
                    text.text = methodNameToRun
                elif argumentIndex > -1:
                    arguments.RemoveAt(argumentIndex)
                    argumentIndex--
                    debugArgs = array(arguments)


            if Input.GetKeyDown(KeyCode.Escape):
                if toggledGraphic.localScale.x > 0.9:
                    Toggle()    

            if Input.GetKeyDown(KeyCode.Return) or Input.GetKeyDown(KeyCode.KeypadEnter):
                for method in availableMethods:
                    if method == methodNameToRun:
                        Commands.Run(methodNameToRun, array(arguments))
                        methodNameToRun = ""
                        Toggle()
                        break

                previousCommand = methodNameToRun
                previousArguments = arguments
                


    public def Toggle():
        if toggledGraphic.localScale.x < 0.9f:
            StartCoroutine(ScaleRoutine(Vector2.one))
            isOpen = true
        else:
            StartCoroutine(ScaleRoutine(Vector2.zero))
            isOpen = false
            methodNameToRun = ""
            arguments.Clear()
            argumentIndex = -1


    private def ScaleRoutine(targetScale as Vector2) as IEnumerator:
        elapsedTime = 0f
        t = 0f
        startValue = toggledGraphic.localScale

        while elapsedTime < 0.1f:
            yield WaitForSeconds(0.01f)
            elapsedTime += 0.01f
            t = elapsedTime/0.1f
            t = Mathf.Sin(t * Mathf.PI * 0.5f)
            toggledGraphic.localScale = Vector2.Lerp(startValue, targetScale, t)
        toggledGraphic.localScale = targetScale

        yield