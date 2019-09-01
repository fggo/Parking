<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.parking.board.model.vo.QnaBoard" %>

<%
  List<QnaBoard> list = (ArrayList<QnaBoard>)request.getAttribute("qnalist");
  
%>

<%@ include file="/views/common/header.jsp" %>
  <style>
    body { padding-top: 56px; }
    #menus{font-size:12px;}

  </style>

  <main role="main" class="flex-shrink-0">
    <div class="container">

      <div class="d-flex align-items-center p-3 my-3 text-white-50 bg-primary rounded shadow-sm">
        <!-- <img class="mr-3" src="" alt="" width="48" height="48"> -->
        <img src="<%=request.getContextPath() %>/images/qna.png" class="mr-3" width="60px">
        <div class="lh-100">
          <p class="h5 mb-0 text-white lh-100">&nbsp;</i>Q&A Board</p>
          <small>Since 2019.08.13</small>
        </div>
      </div>
  
      <div class="my-3 p-3 bg-white rounded shadow-sm">
        <section id="board-container">
          <div class="row">
            <h6 class="border-bottom border-gray pb-2 mb-0">Questions</h6>
            <% if(loginMember != null){ %>
              <input type="button" value="write" class= "btn btn-outline-primary" id="qna-add" onclick="writeBoard();">
            <%} %>
          </div>

          <table class="table">
            <thead>
              <tr>
                <th>NO.</th>
                <th>Title</th>
                <th>Author</th>
                <th>Attachment</th>
                <th>Views</th>
              </tr>
            </thead>
            <tbody>
              <% for(QnaBoard b : list){ %>
              <tr>
                <td><%=b.getQnaNo() %> </td>
                <td>
                  <%=b.getQnaTitle() %>
                </td>
                <td>
                  <div class="media text-muted pt-3">
                    <svg class="bd-placeholder-img mr-2 rounded" width="32" height="32" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid slice" focusable="false" role="img" aria-label="Placeholder: 32x32">
                      <title>Placeholder</title><rect width="100%" height="100%" fill="#007bff"></rect>
                      <text x="50%" y="50%" fill="#007bff" dy=".3em">32x32</text>
                    </svg>
                    <p class="media-body pb-3 mb-0 small lh-125 border-bottom border-gray">
                      <strong class="d-block text-gray-dark">@<%=b.getUserCode() %></strong>
                    </p>
                  </div>
                </td>
                <td>
                  <% if(b.getQnaOriginalFile() != null){ %>
                    <img src="<%=request.getContextPath() %>/images/file.png" width="16px">
                  <% } %>
                </td>
                <td><%=b.getQnaReadcount() %></td>
      
              </tr>
              <% } %>
            </tbody>
          </table>

        <small class="d-block text-right mt-3"><a href="#">All updates</a></small>
      </div>
    </div>
  </main>

<%@ include file="/views/common/footer.jsp" %>