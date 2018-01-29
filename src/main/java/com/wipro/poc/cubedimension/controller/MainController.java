package com.wipro.poc.cubedimension.controller;

import com.wipro.poc.cubedimension.model.ResponseModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
public class MainController {

    private static final Logger logger = LoggerFactory.getLogger(MainController.class);

    @Value("${hive.jdbc.driver}")
    private String hiveDriver;

    @Value("${hive.jdbc.url}")
    private String hiveUrl;

    @Value("${hive.jdbc.auth}")
    private String hiveAuth;

    @RequestMapping("/")
    public String home(Map<String, Object> model, HttpServletRequest request) {
        //model.put("message", "HowToDoInJava Reader !!");
        logger.debug("inside home");
        model.put("cubemessage", request.getSession().getAttribute("cubemessage"));
        return "index";
    }

    @RequestMapping(value = "/api/get/databases", method = RequestMethod.GET, produces = "application/json")
    public @ResponseBody
    ResponseModel getAvailableDatabaseNames() {

        Connection con = null;
        Statement stmt = null;
        String sql = null;
        ResultSet res = null;
        List<String> dbList = new ArrayList<String>();
        ResponseModel response = new ResponseModel();
        try {
            Class.forName(hiveDriver);

            con = DriverManager.getConnection(hiveUrl+hiveAuth);
            //con = DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "cloudera");
            stmt = con.createStatement();

            sql = ("show databases");
            res = stmt.executeQuery(sql);
            while (res.next()) {
                logger.debug(res.getString(1));
                dbList.add(res.getString(1));
            }
        } catch (Exception e) {
            logger.error("Exception : "+e.getLocalizedMessage());
            System.exit(1);
        } finally {
            try {
                if (res != null) {
                    res.close();
                }
            } catch (SQLException se1) {
                // Log this
            }
            try {
                if (stmt != null) {
                    stmt.close();
                }
            } catch (SQLException se2) {
                // Log this
            }
            try {
                if (con != null) {
                    con.close();
                }
            } catch (SQLException se3) {
                // Log this
            }
        }
        response.setDbList(dbList);
        return response;
    }


    @RequestMapping(value = "/api/get/tables/{dbName}", method = RequestMethod.GET, produces = "application/json")
    public @ResponseBody
    ResponseModel getAvailableTableNames(@PathVariable String dbName) {

        Connection con = null;
        Statement stmt = null;
        String sql = null;
        ResultSet res = null;
        List<String> tableList = new ArrayList<String>();
        ResponseModel response = new ResponseModel();
        try {
            Class.forName(hiveDriver);

            //replace "hive" here with the name of the user the queries should run as
            con = DriverManager.getConnection(hiveUrl+"/"+ dbName+hiveAuth);
            //con = DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "cloudera");
            stmt = con.createStatement();

            sql = ("show tables");
            res = stmt.executeQuery(sql);
            while (res.next()) {
                logger.debug(res.getString(1));
                tableList.add(res.getString(1));
            }
        } catch (Exception e) {
            logger.error("Exception : "+e.getLocalizedMessage());
            System.exit(1);
        } finally {
            try {
                if (res != null) {
                    res.close();
                }
            } catch (SQLException se1) {
                // Log this
            }
            try {
                if (stmt != null) {
                    stmt.close();
                }
            } catch (SQLException se2) {
                // Log this
            }
            try {
                if (con != null) {
                    con.close();
                }
            } catch (SQLException se3) {
                // Log this
            }
        }
        response.setTableList(tableList);
        return response;

    }

    @RequestMapping(value = "/api/get/columns/{dbName}/{tableName}", method = RequestMethod.GET, produces = "application/json")
    public @ResponseBody
    ResponseModel getColumnNames(@PathVariable String dbName, @PathVariable String tableName) {

        String driverName =  hiveDriver;
        Connection con = null;
        Statement stmt = null;
        String sql = null;
        ResultSet res = null;
        List<String> tableList = new ArrayList<String>();
        ResponseModel response = new ResponseModel();
        List<String> columnList = new ArrayList<String>();
        try {
            Class.forName(driverName);

            //replace "hive" here with the name of the user the queries should run as
            //con = DriverManager.getConnection("jdbc:hive2://localhost:10000/" + dbName);
            con = DriverManager.getConnection(hiveUrl+"/"+ dbName+hiveAuth);
            ResultSet rs = con.createStatement().executeQuery("select * from " + dbName + "." + tableName + "  limit 1");
            ResultSetMetaData metaData = rs.getMetaData();

            for (int i = 1; i <= metaData.getColumnCount(); i++) {
                String colName = metaData.getColumnLabel(i).replaceFirst(tableName.toLowerCase() + ".", "");
                columnList.add(colName);

            }
        } catch (Exception e) {
            // TODO Auto-generated catch block
            logger.error("Exception : "+e.getLocalizedMessage());
            System.exit(1);
        } finally {
            try {
                if (res != null) {
                    res.close();
                }
            } catch (SQLException se1) {
                // Log this
            }
            try {
                if (stmt != null) {
                    stmt.close();
                }
            } catch (SQLException se2) {
                // Log this
            }
            try {
                if (con != null) {
                    con.close();
                }
            } catch (SQLException se3) {
                // Log this
            }
        }
        response.setColumnList(columnList);
        return response;

    }

    @PostMapping("/api/saveDetails")
    public String saveDetails(@RequestParam("modelName") String modelName,
                              @RequestParam("capturedTable") String capturedTable,
                              @RequestParam("cube") String cube,
                              @RequestParam("description") String description,
                              @RequestParam("capturedDimension") String capturedDimension,
                              @RequestParam("capturedMeasure") String capturedMeasure,
                              Map<String, Object> model,
                              HttpServletRequest request
    ) {
        logger.debug("model name : " + modelName);
        logger.debug("cube : " + cube);
        logger.debug("description : " + description);
        logger.debug("capturedDimension : " + capturedDimension);
        logger.debug("capturedMeasure : " + capturedMeasure);
        request.getSession().setAttribute("cubemessage","");
        String dimArray[] = capturedDimension.split(",");
        String measureArray[] = capturedMeasure.split(",");
        String tableArray[] = capturedTable.split(",");

        try (BufferedWriter writer = Files.newBufferedWriter(Paths.get("/tmp/cube.txt"))) {
            for (int i = 0; i < tableArray.length; i++) {
                writer.write("table=" + tableArray[i] + "\n");
            }
            writer.write("cube=" + cube + "\n");
            writer.write("description=" + description + "\n");
            for (int i = 0; i < dimArray.length; i++) {
                writer.write("dim=" + dimArray[i] + "\n");
            }
            for (int i = 0; i < measureArray.length; i++) {
                writer.write("mea=" + measureArray[i] + "\n");
            }

        } // the file will be automatically closed
        catch (Exception ex) {

        }

        //Execute script file
        /*String[] env = {"PATH=/bin:/usr/bin/"};
        String scriptName = "sh /tmp/cubeTrigger.sh";
        String commands[] = new String[]{scriptName};
        int status=-1;
        Runtime rt = Runtime.getRuntime();
        Process process = null;
        try{
            process = rt.exec(commands,env);
            //status=process.waitFor();
            logger.debug("status of runtime script process : "+status);
            if(process.exitValue() ==0){
                return "Cube information saved successfully";
            }else{
                return "Error occured";
            }
        }catch(Exception e){
            e.printStackTrace();
            return "Error occured";
        }*/

        String cmd = "/tmp/cubeTrigger.sh";
        logger.debug(" Begin : trigger : "+cmd+ " using ProcessBuilder");
        ProcessBuilder pb = new ProcessBuilder("/bin/bash",cmd);
        try {
            logger.debug("about to trigger : "+cmd+ " using ProcessBuilder");
            Process process = pb.start();
            logger.debug("Triggered");
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            StringBuilder builder = new StringBuilder();
            String line = null;

            while ((line = reader.readLine()) != null) {
                builder.append("");
                builder.append(line == null ? "" : line);
                builder.append("<br/>");
                builder.append(line);
            }
            String result = builder.toString();
            logger.debug(result);
            logger.debug("end of script execution");
            process.waitFor();
            logger.debug("Process exit status : "+process.exitValue());
            //model.put("cubemessage","Cube Details captured successfully");
            request.getSession().setAttribute("cubemessage","Cube Details captured successfully");
            if(process.exitValue() == 0){
               return "redirect:/";
                //return "Cube Details captured successfully";
            }else{
                return "redirect:/";
                //return "Trigger script execution failed: "+result;
            }
        } catch (IOException e) {
            logger.debug("error");
            e.printStackTrace();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        model.put("cubemessage","Cube Details captured successfully");
        return "index";
        //return "Cube Details captured successfully";
        //return "ss";

    }



    @RequestMapping("/next")
    public String next(Map<String, Object> model) {
        model.put("message", "You are in new page !!");
        return "next";
    }
}
