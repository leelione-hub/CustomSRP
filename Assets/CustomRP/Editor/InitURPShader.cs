using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

public class InitURPShader : EditorWindow
{

    static InitURPShader _ins;
    private const string SHADERNAME = "SHADERNAME";

    [MenuItem("Tool/Shader/URPShader")]
    static void CreateIns()
    {
        _ins=EditorWindow.GetWindow<InitURPShader>();
        _ins.Show();
    }

    string shaderName="Custom_";
    void OnGUI()
    {
        shaderName=EditorGUILayout.TextField("ShaderName:",shaderName);
        if(GUILayout.Button("生成一个UnlitShader模板"))
        {
            CreateDefaultURPShader();
        }
    }

    
    void CreateDefaultURPShader()
    {
        string shaderCodePath="Assets/CustomRP/Editor/ShaderCode/Unlit.txt";
        string name = shaderName+".shader";
        var directory = EditorUtility.OpenFolderPanel("Select Folder","Assets/Shader/URP/",null);
        string newpath = Path.Combine(directory,name);
        Debug.Log(newpath);
        StreamReader sr =new StreamReader(shaderCodePath);
        string code = sr.ReadToEnd();
        sr.Close();
        code = code.Replace(SHADERNAME,shaderName);
        StreamWriter sw = new StreamWriter(newpath);
        sw.Write(code);
        sw.Flush();
        sw.Close();
        AssetDatabase.Refresh();
        Selection.activeObject=AssetDatabase.LoadAssetAtPath(newpath,typeof(Shader));
    }
    
}
