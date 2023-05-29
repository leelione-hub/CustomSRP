using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[ExecuteInEditMode]
public class UIClipRect : MonoBehaviour
{
    [SerializeField]private Vector4 m_clipRect;
    [SerializeField]private MeshRenderer m_meshRenderer;
    [SerializeField] private Mask mask;
    public Vector3 maskCenter;
    private MaterialPropertyBlock m_materialPropertyBlock;
    public void OnEnable()
    {
        if (m_meshRenderer == null)
        {
            m_meshRenderer = this.GetComponent<MeshRenderer>();
        } 
    }

    private void Update()
    {
        GetMaskRect();
        SetColorPropertyBlock(m_meshRenderer);
    }

    void SetColorPropertyBlock(Renderer renderer)
    {
        if (m_materialPropertyBlock == null)
        {
            m_materialPropertyBlock=new MaterialPropertyBlock();
        }
        m_materialPropertyBlock.SetVector("_ClipRect", m_clipRect);
        renderer.SetPropertyBlock(m_materialPropertyBlock);
        Debug.Log(m_materialPropertyBlock.GetVector("_ClipRect"));
    }

    public Vector2 size;
    void GetMaskRect()
    {
        // var rectTransform = mask.rectTransform;
        // Vector3[] worldPos=new Vector3[4];
        // rectTransform.GetWorldCorners(worldPos);

        // var scale = rectTransform.localScale;
        // maskCenter = rectTransform.localToWorldMatrix.MultiplyPoint(Vector3.zero);
        // size = rectTransform.sizeDelta;
        // size.x*=scale.x;
        // size.y*=scale.y;
        // Vector2 leftdownp = new Vector2(maskCenter.x-size.x/2,maskCenter.y-size.y/2);
        // Vector2 rightupp = new Vector2(maskCenter.x+size.x/2,maskCenter.y+size.y/2);
        //m_clipRect = new Vector4(leftdownp.x,leftdownp.y,rightupp.x,rightupp.y);
        var rectTransform = mask.rectTransform;
        Canvas canvas = mask.GetComponentInParent<Canvas>();
        GetMaskRect(rectTransform,canvas);
    }

    public Vector3[] worldPos=new Vector3[4];
    void GetMaskRect(RectTransform rectTransform,Canvas canvas)
    {
        
        rectTransform.GetWorldCorners(worldPos);

        //左下
        Vector3 lbPos = worldPos[0];
        //右上
        Vector3 rtPos = worldPos[2];

        RectTransform rectTransCanvas = canvas.GetComponent<RectTransform>();
        
        lbPos = Camera.main.WorldToScreenPoint(lbPos);
        RectTransformUtility.ScreenPointToLocalPointInRectangle(rectTransCanvas,lbPos,Camera.main,out Vector2 localLbPos);
        rtPos = Camera.main.WorldToScreenPoint(rtPos);
        RectTransformUtility.ScreenPointToLocalPointInRectangle(rectTransCanvas,rtPos,Camera.main,out Vector2 localRtPos);
        //m_clipRect=new Vector4(localLbPos.x,localLbPos.y,localRtPos.x,localRtPos.y);
        m_clipRect=new Vector4(worldPos[0].x,worldPos[0].y,worldPos[2].x,worldPos[2].y);
    }
}
