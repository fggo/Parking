package com.parking.board.model.dao;

import static common.template.JDBCTemplate.close;

import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import com.parking.board.model.vo.QnaBoard;

public class QnaBoardDao {
  private Properties prop = new Properties();

  public QnaBoardDao() {
    try {
      String path = QnaBoardDao.class.getResource("/sql/board/board-query.properties").getPath();
      prop.load(new FileReader(path));
    } catch(IOException e) {
      e.printStackTrace();
    }
  }

  public List<QnaBoard> selectQnaBoardList(Connection conn){
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    List<QnaBoard> list = new ArrayList<QnaBoard>();
    QnaBoard b = null;

    String sql = prop.getProperty("selectQnaBoardList");
    
    try {
      pstmt = conn.prepareStatement(sql);
      rs = pstmt.executeQuery();
      
      while(rs.next()) {
        b = new QnaBoard();

        b.setQnaNo(rs.getInt("qna_no"));
        b.setQnaTitle(rs.getString("qna_title"));
        b.setUserCode(rs.getString("user_code"));
        b.setQnaContent(rs.getString("qna_content"));
        b.setQnaOriginalFile(rs.getString("qna_original_filename"));
        b.setQnaRenamedFile(rs.getString("qna_renamed_filename"));
        b.setQnaCreatedDate(rs.getDate("qna_created_date"));
        b.setQnaReadcount(rs.getInt("qna_readcount"));
        
        list.add(b);
      }
      
    } catch(SQLException e) {
      e.printStackTrace();
    } finally {
      close(rs);
      close(pstmt);
    }
    
    return list;
  }
}