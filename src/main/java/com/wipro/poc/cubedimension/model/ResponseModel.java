package com.wipro.poc.cubedimension.model;

import java.io.Serializable;
import java.util.List;

public class ResponseModel implements Serializable {

    private List<String> dbList;
    private List<String> tableList;
    private List<String> columnList;


    public List<String> getDbList() {
        return dbList;
    }

    public void setDbList(List<String> dbList) {
        this.dbList = dbList;
    }

    public List<String> getTableList() {
        return tableList;
    }

    public void setTableList(List<String> tableList) {
        this.tableList = tableList;
    }

    public List<String> getColumnList() {
        return columnList;
    }

    public void setColumnList(List<String> columnList) {
        this.columnList = columnList;
    }


}
