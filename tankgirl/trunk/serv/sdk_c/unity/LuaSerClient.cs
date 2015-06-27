using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using System.Net;
using System.Net.Sockets;
using System.Text;


/// <param name="msgID">消息ID</param>
/// <param name="body">消息体内容。只是字节数组，未反序列化。反序列化是每个包的handler自己的责任</param>
/// <param name="begin">body的[begin.end)区间是有效区间；其他范围不是本包的，不应该访问</param>
public delegate int MsgHandler(UInt16 msgID,byte[] body,int begin,int end);

public class LuaSerClient : MonoBehaviour {

	// Use this for initialization
	void Start () {
		// for TEST only
		Test1();
	}
	
	// Update is called once per frame
	void Update () {
	}

	void LateUpdate(){
		int r = TryRecv();
	}

	public string remoteIP;
	public int remotePort;
	private Socket sock;
	private byte[] sendbuf = new byte[1024];
	private byte[] recvbuf = new byte[1024*32];
	private Dictionary<UInt16,MsgHandler> dic = new Dictionary<UInt16,MsgHandler>();


	// 重要：注册消息handler
	public void RegMsgHandler(UInt16 msgID,MsgHandler hd){
		dic[msgID] = hd;
	}

	public int ConnectToServer(){
		try {
			sock = new Socket(AddressFamily.InterNetwork,
			                  SocketType.Stream, ProtocolType.Tcp);

			sock.NoDelay = true;
			sock.ReceiveBufferSize = 8192;
			sock.SendBufferSize = 8192;
			sock.ReceiveTimeout = 1;
			
			sock.Connect(remoteIP,remotePort);

			return 1;
		}
		catch (Exception e) {
			Debug.Log(e.ToString());

			return 0;
		}
	}

	public int SendMsg(ushort msgID,byte[] msg_body){
		try {
			ushort body_len = (ushort)msg_body.Length;
			ushort full_len = (ushort)(body_len+4);

			int offset = 0;
			BitConverter.GetBytes(full_len).CopyTo(sendbuf,offset);
			offset += 2;

			BitConverter.GetBytes(msgID).CopyTo(sendbuf,offset);
			offset += 2;

			if(body_len>0){
				msg_body.CopyTo(sendbuf,offset);
				offset += body_len;
			}

			return sock.Send(sendbuf,offset,SocketFlags.None);
		}
		catch (Exception e) {
			Debug.Log(e.ToString());
			return -1;
		}
	}

	public int TryRecv(){
		try {
			if(sock.Available>0){
				int r = sock.Receive(recvbuf);
				if(r>0){
					Debug.Log("recv "+r);

					if(r>=4){
						UInt16 len = BitConverter.ToUInt16(recvbuf,0);
						UInt16 msg_id = BitConverter.ToUInt16(recvbuf,2);

						MsgHandler hd = dic[msg_id];
						if(null != hd){
							hd(msg_id,recvbuf,4,len);
						}


						return 0;
					}
					else{
						return -1;
					}
				}
			}

			return 0;
		}
		catch (Exception e) {
			Debug.Log(e.ToString());
			return 0;
		}
	}

	public int Test1(){
		try {
			remoteIP = "127.0.0.1";
			remotePort = 54388;

			if(ConnectToServer()>0){
				Debug.Log("begin send");
				int r = SendMsg(1,new byte[10]);
				Debug.Log("send return "+r);
			}

			RegMsgHandler(2,(id,body,be,en)=>{
				Debug.Log("get msg "+id+"  "+be+"  "+en);
				return 0;
			});

			return 1;
		}
		catch (Exception e) {
			Debug.Log(e.ToString());
			return 0;
		}
	}
}
