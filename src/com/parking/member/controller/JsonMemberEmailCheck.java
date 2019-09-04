package com.parking.member.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.google.gson.Gson;
import com.parking.member.model.service.MemberService;
import com.parking.member.model.vo.Member;

/**
 * Servlet implementation class JsonMemberEmailCheck
 */
@WebServlet("/member/JsonMemberEmailcheck")
public class JsonMemberEmailCheck extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public JsonMemberEmailCheck() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		JSONObject jobj = new JSONObject();
		String email = request.getParameter("userEmail");
		System.out.println("email:"+email);
		
		MemberService service = new MemberService();
		
		Member m = service.selectEmail(email);
		List<Member> list = new ArrayList<Member>();
		if(m != null)
		{
			list.add(m);
			System.out.println("m : " + m.toString());
			
			JSONArray jlist = new JSONArray();
			
			for(Member member : list)
			{
				JSONObject jo = new JSONObject();
				jo.put("userCode", member.getUserCode());
				jo.put("email", member.getEmail());
				jo.put("pw", member.getPw());
				jo.put("phone", member.getPhone());
				jo.put("userName", member.getUserName());
				jo.put("userAddr", member.getUserAddr());
				jo.put("createdDate", member.getCreatedDate());
				jo.put("loginDate", member.getLoginDate());
				jo.put("smsYn", member.isSmsYn());
				jo.put("emailYn", member.isEmailYn());
				jo.put("emailVerified", member.isEmailVerified());
				jlist.add(jo);
			}
			
			System.out.println(jlist.get(0).toString());
			
			response.setContentType("application/json;charset=UTF-8");
			new Gson().toJson(list,response.getWriter());		
		}else
		{
			Member m1 = new Member();
			list.add(m1);
			
			JSONArray jlist = new JSONArray();
			
			for(Member member : list)
			{
				JSONObject jo = new JSONObject();
				jo.put("userCode", member.getUserCode());
				jo.put("email", member.getEmail());
				jo.put("pw", member.getPw());
				jo.put("phone", member.getPhone());
				jo.put("userName", member.getUserName());
				jo.put("userAddr", member.getUserAddr());
				jo.put("createdDate", member.getCreatedDate());
				jo.put("loginDate", member.getLoginDate());
				jo.put("smsYn", member.isSmsYn());
				jo.put("emailYn", member.isEmailYn());
				jo.put("emailVerified", member.isEmailVerified());
				jlist.add(jo);
			}
			response.setContentType("application/json;charset=UTF-8");
			new Gson().toJson(list,response.getWriter());
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
