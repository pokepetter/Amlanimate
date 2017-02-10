import UnityEngine
import UnityEngine.UI
import System.IO

class PaletteButton (MonoBehaviour): 

    public image as Image

    private button as Button
    private currentDirectory as string
    private files as (string)

    private fileData as (byte)
    private texture as Texture2D

    private colorAsStrings as (string)


    def Awake():
        button = GetComponent(Button)
        button.onClick.AddListener({Click()})
        image = GetComponent(Image)

        currentDirectory = Directory.GetCurrentDirectory() + "/" + "Palettes" //use "\\"" on windows
        RefreshPalettes()
        LoadPalette(0)


    def RefreshPalettes():
        files = System.IO.Directory.GetFileSystemEntries(currentDirectory, "*.png")
        for f in files:
            print(f)


    def LoadPalette(index as int):
        if files.Length > 0 and File.Exists(files[index]):
            fileData = File.ReadAllBytes(files[index])
            texture = Texture2D.blackTexture
            texture.filterMode = FilterMode.Point
            texture.LoadImage(fileData) //this will auto-resize the texture dimensions.
            newSprite = Sprite.Create(texture, Rect(0.0f, 0.0f, texture.width, texture.height), Vector2.one)
            image.sprite = newSprite
            GetComponent(RectTransform).sizeDelta = Vector2(texture.width, texture.height)

        print("no such palette")


    def Click():
        color = texture.GetPixel(0, 0)
        colorAsStrings = (color.r.ToString(), color.g.ToString(), color.b.ToString(), color.a.ToString())
        Commands.Run("SelectColor", colorAsStrings)