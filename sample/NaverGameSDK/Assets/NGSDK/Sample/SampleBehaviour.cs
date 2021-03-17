using UnityEngine;
using System;
using System.Collections;
using System.Text.RegularExpressions;
using System.IO;

public class SampleBehaviour : MonoBehaviour {

    [Header("NAVER GAME Lounge ID")]
	// public string LoungeId = "TEST";
	public string LoungeId = "League_of_Legends";

	[Header("NAVER GAME ClientId")]
	// public string NaverLoginClientId = "197CymaStozo7X5r2qR5";
	public string NaverLoginClientId = "6heF5G8dkbmv545M2ccR";
	
	[Header("NAVER GAME ClientSecret")]
	// public string NaverLoginClientSecret = "evCgKH1kJL";
	public string NaverLoginClientSecret = "OuLD_GynxF";
	
    void Start()
    {
        GLink.sharedInstance().init(LoungeId, NaverLoginClientId, NaverLoginClientSecret);
    }

    public void OnClickGlinkButton () {
		Debug.Log("click!");
		GLink.sharedInstance().executeHomeBanner();
	}
}


