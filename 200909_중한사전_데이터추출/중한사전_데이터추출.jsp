<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/cndic/jsp/baseLib.jsp" %>
<%@ page import="java.util.arrayList.*"%>
<%@ page import="java.util.regex.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.lang.*"%>


<%
	/************************************************
	* PrintWriter 선언
	************************************************/
	PrintWriter writer = response.getWriter();
	
	
	/************************************************
	* DB 처리용 변수들
	************************************************/
	StringBuffer returnSB =null;
	StringBuffer sb = null;
	StringBuffer sb2 = null;
	StringBuffer sb3 = null;
	
	/************************************************
	* File IO 정의
	************************************************/
	String fileDir = "cndic/"; //파일을 생성할 디렉토리
  	String filePath = request.getRealPath(fileDir) + "/"; //파일을 생성할 전체경로
  	String writeFile = "extract_sample.txt"; //쓸 파일명
  	
  	writeFile = filePath+writeFile; //생성할 파일명을 전체경로에 결합
  	
  	
  	
	BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(
						new FileOutputStream(writeFile), "utf-8"));
	
	
	/************************************************
	* DB 처리용 변수들 선언 및 초기화
	************************************************/
	boolean msg = true; // Message Popup!
	StringBuffer chk = new StringBuffer();
	
	Date d = new Date(); 
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
	String workTime = df.format(d);

	
	/************************************************
	* SQL 처리용 변수들
	************************************************/
	Connection conn = null;
	PreparedStatement statement = null;
	ResultSet rs = null;
	ResultSet rs1 = null;
	ResultSet rs2 = null;
	String query = null;
	
	String sqlEnt = "SELECT * FROM kuck_entries WHERE entry_id=?";
	String sqlSen = "SELECT * FROM kuck_senses WHERE entry_id=?";
	String sqlExm = "SELECT * FROM kuck_examples WHERE sense_id=?";
	String sqlVar = "SELECT * FROM kuck_variants WHERE hanja_no=?";
	
	PreparedStatement psEnt = null;
	PreparedStatement psSen = null;
	PreparedStatement psExm = null;
	PreparedStatement psVar = null;
	
	String sense_id = "";
	String entry_id = "";
	String hanja_no = "";
	
	ArrayList<String> headword_id_arr=new ArrayList<String>();
	//ArrayList<String> hsk_p=new ArrayList<String>();
	//ArrayList<String> hsk_n=new ArrayList<String>();
	
	String line = ""; 
	
	try {
		Class.forName(MySqlDriver);
		conn = DriverManager.getConnection(dbUrl, dbId, dbPwd);
		
		psEnt = conn.prepareStatement(sqlEnt);
		psVar = conn.prepareStatement(sqlVar);
		psSen = conn.prepareStatement(sqlSen);
		psExm = conn.prepareStatement(sqlExm);
		
		//query = "select * from temp_update_table_ck";
		query = "SELECT sen.entry_id AS id FROM kuck_senses sen LEFT JOIN kuck_entries ent ON sen.entry_id = ent.entry_id WHERE sen.entry_id>219692 AND sen.class_1st_val LIKE '%%' AND sen.class_2nd_val = '' AND sen.class_3rd_val = '' AND sen.class_2nd_ord = '' AND sen.class_1st_ord = '' AND sen.class_3rd_ord = '' AND ent.state='등록' ORDER BY ent.hanja_no, ent.pinyin_std "; 
		statement = conn.prepareStatement(query);
		rs=statement.executeQuery();
		while(rs.next()){
			headword_id_arr.add(rs.getString("id"));
			//hsk_p.add(rs.getString("hsk_p"));
			//hsk_n.add(rs.getString("hsk_n"));
		}
		rs.close();
		/*표제어*/
		
		String tmpHeadword ="";
		String tmpPinyinVar = "";
		String tmpRtermGlb = ""; 
		String tmpUseform = "";
		for(int i=0;headword_id_arr.size()>i;i++){
			tmpPinyinVar = "";
			tmpRtermGlb = "";
			tmpUseform = "";
			
			entry_id = headword_id_arr.get(i).toString();
			if(!tmpHeadword.equals(entry_id)){

					returnSB = new StringBuffer();
					sb = new StringBuffer();
					sb2 = new StringBuffer();
					sb3 = new StringBuffer();
					
	
					// 표제어부 정보 처리
					psEnt.setString(1, entry_id);
					rs1 = psEnt.executeQuery();
					if(rs1.next()) {
						sb.append("["+rs1.getString("headword"));
						
						if(rs1.getString("headword").length()==1){
							hanja_no = rs1.getString("hanja_no");
							psVar.setString(1,hanja_no);
							rs2 = psVar.executeQuery();
							while(rs2.next()){
								if(rs2.getString("variant_type").equals("번체자")){
									sb.append("\u2027"+rs2.getString("variant_class")+rs2.getString("variant_char"));
								}
								else if(rs2.getString("variant_type").equals("이체자")){
									sb.append("("+rs2.getString("variant_class")+rs2.getString("variant_char")+")");
								}
							}
						}
						sb.append("]"+" ");
						if(!rs1.getString("pinyin_std").equals("")) sb.append(rs1.getString("pinyin_std")+" ");
						if(!rs1.getString("pinyin_app").equals("")) sb.append(rs1.getString("pinyin_app")+" ");
						if(!rs1.getString("hanja_pam").equals("")) sb.append(rs1.getString("hanja_pam")+" ");
						if(!rs1.getString("pinyin_var").equals("")) tmpPinyinVar = rs1.getString("pinyin_var");
						/*if(!hsk_p.get(i).toString().equals("")){
							switch(hsk_p.get(i).charAt(0)){
								case '갑' : sb.append("{HSK甲} "); break;
								case '을' : sb.append("{HSK乙} "); break;
								case '병' : sb.append("{HSK丙} "); break;
								case '정' : sb.append("{HSK丁} "); break;
							}
						}
						String tmp = hsk_n.get(i).toString().replace(System.getProperty("line.separator"),"");
						tmp = tmp.substring(0,tmp.length()-1);
						if(!tmp.equals("")) sb.append("{신HSK"+tmp+"급} ");*/
						
					}
					rs1.close();
					
					
					
					//뜻풀이부 정보 처리
					psSen.setString(1,entry_id);
					rs1 = psSen.executeQuery();
					while(rs1.next()){
						if(!rs1.getString("class_1st_ord").equals("")) sb.append(rs1.getString("class_1st_ord")+" ");
						if(!rs1.getString("class_1st_val").equals("")) sb.append(rs1.getString("class_1st_val")+" ");
						if(!rs1.getString("class_2nd_ord").equals("")) sb.append(rs1.getString("class_2nd_ord")+" ");
						if(!rs1.getString("class_2nd_val").equals("")) sb.append(rs1.getString("class_2nd_val")+" ");
						if(!rs1.getString("class_3rd_ord").equals("")) sb.append(rs1.getString("class_3rd_ord")+" ");
						if(!rs1.getString("class_3rd_val").equals("")) sb.append(rs1.getString("class_3rd_val")+" ");
						sb.append(rs1.getString("sense")+" ");
						
						sense_id = rs1.getString("sense_id");
						psExm.setString(1,sense_id);
						rs2 = psExm.executeQuery();
						while(rs2.next()){
							if(!rs2.getString("example_cn").equals("")){
								sb.append("「"+rs2.getString("example_cn")+";"+rs2.getString("example_kr")+rs2.getString("example_rt")+"」 ");
							}
						}
						
						if(!rs1.getString("rterm_std").equals("")) sb.append(rs1.getString("rterm_std")+" ");
						if(!rs1.getString("rterm_syn").equals("")) sb.append(rs1.getString("rterm_syn")+" ");
						if(!rs1.getString("rterm_ant").equals("")) sb.append(rs1.getString("rterm_ant")+" ");
						if(!rs1.getString("rterm_ref").equals("")) sb.append(rs1.getString("rterm_ref")+" ");
						if(!rs1.getString("rterm_glb").equals("")) tmpRtermGlb = rs1.getString("rterm_glb");
						if(!rs1.getString("useform").equals("")&&rs1.getString("useform").indexOf("∥")==-1) sb.append(rs1.getString("useform")+" ");
						if(!rs1.getString("useform").equals("")&&rs1.getString("useform").indexOf("∥")>-1) tmpUseform = rs1.getString("useform");
					
					}
					sb.append(tmpUseform+" ");
					sb.append(tmpRtermGlb+" ");
					sb.append(tmpPinyinVar+" ");
					
					returnSB.append(sb.toString()+"\r\n");
					bw.write(returnSB.toString());
					returnSB = null;
					
			}
			
			tmpHeadword = entry_id;
		}
		/*뜻풀이*/
		
		
		
	
		
	} catch (Exception e) {
		writer.print("#Exception: " + e.getMessage());
		writer.close();
  	} finally {
		try {
			if (statement != null) statement.close();
			if (conn != null) conn.close();
			
			if (bw != null) bw.close();
			/*
		    bwA.close();
			bwB.close();
			bwC.close();
			bwD.close();
			bwE.close();
			bwF.close();
			*/
		} catch (SQLException sqle) {
			writer.print("#Exception SQL close: " + sqle.getMessage());
			writer.close();
		}
 	}
 	
%>
	