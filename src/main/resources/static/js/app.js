var app = angular.module('app', []);

app.controller('AppController', ['$scope', '$http', '$rootScope', function ($scope, $http, $rootScope) {

    $scope.criteria = {
        "dbName" : "",
        "tableName" : ""

    }

    $scope.databases = [];
    $scope.tables = [];
    $scope.columns = [];
    var index =0;

    $http({
        url : "api/get/databases",
        method:"GET"

    }).success(function (response) {
        //var dat = response.dbList;
        //$scope.databases = dat.dbList;
        index=0;
        while(index < response.dbList.length){
            $scope.databases.push(response.dbList[index]);
            index++;
        }
        console.log(response.dbList.length);

    });

    /*function fetchTableName(databaseName){
        alert('inside');
        $http({
            url : "api/get/tables/"+databaseName,
            method:"GET"

        }).success(function (response) {
            //var dat = response.dbList;
            //$scope.databases = dat.dbList;
            index=0;
            while(index < response.tableList.length){
                $scope.tables.push(response.tableList[index]);
                index++;
            }
            console.log(response.tableList.length);

        });
    }*/


    $scope.fetchColumnNames = function(indexNumber){
        //alert(indexNumber);
        var tableIndex = "tableName"+indexNumber;
        var colIndex = "columns"+indexNumber;
        var tableName = $scope[tableIndex];
        var dbName = $scope.modelName;
        $scope[colIndex]=[];

        $http({
            url : "api/get/columns/"+dbName+"/"+tableName,
            method:"GET"

        }).success(function (response) {
            //var dat = response.dbList;
            //$scope.databases = dat.dbList;
            index=0;
            //$("#colName option").remove();


            while(index < response.columnList.length){
                $scope[colIndex].push(response.columnList[index]);
                index++;
            }
            console.log(response.columnList.length);

        });


    }

    $scope.fetchColumnNamesMeasure = function(indexNumber){
        //alert(indexNumber);
        var tableIndex = "factTableName"+indexNumber;
        var colIndex = "measureColumns"+indexNumber;
        var tableName = $scope[tableIndex];
        var dbName = $scope.modelName;
        $scope[colIndex]=[];

        $http({
            url : "api/get/columns/"+dbName+"/"+tableName,
            method:"GET"

        }).success(function (response) {
            //var dat = response.dbList;
            //$scope.databases = dat.dbList;
            index=0;
            //$("#colName option").remove();


            while(index < response.columnList.length){
                $scope[colIndex].push(response.columnList[index]);
                index++;
            }
            console.log(response.columnList.length);

        });


    }


}]);