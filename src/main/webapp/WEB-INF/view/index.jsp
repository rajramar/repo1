<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <%@ page isELIgnored="false" %>
    <title>Cube Designer</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Include Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
    <!-- Optional Bootstrap theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">

    <!-- Latest compiled and minified CSS for select box -->
    <link rel="stylesheet" href="css/bootstrap-select.min.css">

    <!-- Include SmartWizard CSS -->
    <link href="css/smart_wizard.css" rel="stylesheet" type="text/css" />

    <!-- Optional SmartWizard theme -->
    <link href="css/smart_wizard_theme_dots.css" rel="stylesheet" type="text/css" />
    <!-- Latest compiled and minified JavaScript -->
    <script src="js/bootstrap-select.js" type="text/javascript"></script>
    <script src="js/angular.min.js" type="text/javascript"></script>
    <script src="js/app.js" type="text/javascript"></script>

</head>
<body ng-app="app" ng-controller="AppController">
<div class="container">
    <br />
    <form action="api/saveDetails" id="myForm" role="form" data-toggle="validator" method="post" accept-charset="utf-8">
        <input type="hidden" name="capturedDimension" id="capturedDimension" value="" />
        <input type="hidden" name="capturedMeasure" id="capturedMeasure" value=""/>
        <input type="hidden" name="capturedTable" id="capturedTable" value=""/>
        <!-- SmartWizard html -->
        <div id="smartwizard">
            <ul>
                <li><a href="#step-1">Step 1<br /><small>Cube Info</small></a></li>
                <li><a href="#step-2">Step 2<br /><small>Dimensions</small></a></li>
                <li><a href="#step-3">Step 3<br /><small>Measures</small></a></li>
                <li><a href="#step-4">Step 4<br /><small>Overview and Save</small></a></li>
            </ul>

            ${cubemessage}
            <div>
                <div id="step-1">
                    <h2>Cube Info</h2>
                    <div id="form-step-0" role="form" data-toggle="validator">
                        <div class="form-group">

                            <label for="modelName">Model Name:</label>
                            <select class="form-control" name="modelName" id="modelName" style="width:35%" ng-model="modelName">
                                <option ng-repeat="ab in databases">{{ab}}</option>
                            </select>

                            <label for="cube">Cube Name:</label>
                            <input type="text" class="form-control" style="width:35%" name="cube" ng-model="cubeName" id="cube" placeholder="Enter Cube Name" required>
                            <div class="help-block with-errors"></div>

                            <label for="description">Description:</label>
                            <textarea class="form-control" name="description" id="description" ng-model="description" rows="3" placeholder="Description."></textarea>

                        </div>
                    </div>

                </div>
                <div id="step-2">
                    <h2>Dimension</h2>
                    <div id="form-step-1" role="form" data-toggle="validator">
                        <div class="form-group">
                            <label for="dimensionName1">Name:</label>
                            <input type="text" class="form-control" style="width:35%" name="dimensionName1" ng-model="dimensionName1" id="dimensionName1" placeholder="Dimension name">

                            <label for="tableName1">Table Name:</label>
                            <select class="form-control" id="tableName1" style="width:35%" ng-model="tableName1" ng-change="fetchColumnNames(1)">
                                <option>Select table</option>
                            </select>

                            <label for="colName1">Column Name:</label>
                            <select class="form-control" id="colName1" style="width:35%" ng-model="colName1">
                                <option ng-repeat="col in columns1">{{col}}</option>
                            </select>
                            <br/>
                            <button type="button" class="btn" onclick="addDimension()">Add</button>

                        </div>
                    </div>
                </div>
                <div id="step-3">
                    <h2>Measure</h2>
                    <div id="form-step-2" role="form" data-toggle="validator">
                        <div class="form-group">
                            <label for="measureName1">Name:</label>
                            <input type="text" class="form-control" style="width:35%" name="measureName1" id="measureName1" placeholder="Measure name">

                            <label for="factTableName1">Table Name:</label>
                            <select class="form-control" id="factTableName1" style="width:35%" ng-model="factTableName1" ng-change="fetchColumnNamesMeasure(1)">
                                <option>Select Fact table</option>
                            </select>

                            <label for="measureExpression1">Expression:</label>
                            <select class="form-control" id="measureExpression1" style="width:35%" ng-model="measureExpression1">
                                <option value="SUM">SUM</option>
                                <option value="MAX">MAX</option>
                                <option value="MIN">MIN</option>
                                <option value="COUNT">COUNT</option>
                                <option value="COUNT_DISTINCT">COUNT_DISTINCT</option>
                                <option value="TOP_N">TOP_N</option>

                            </select>

                            <label for="measureColName1">Column Name:</label>
                            <select class="form-control" id="measureColName1" style="width:35%" ng-model="measureColName1">
                                <option ng-repeat="col in measureColumns1">{{col}}</option>
                            </select>
                            <br/>
                            <button type="button" class="btn" onclick="addMeasure()">Add</button>

                        </div>
                    </div>
                </div>
                <div id="step-4" class="">
                    <h2>Overview</h2>
                    <br>
                    <label for="overview_model">Model Name  :  </label> {{modelName}}
                    <br>
                    <label for="overview_cube">Cube Name  :  </label> {{cubeName}}
                    <br>
                    <label for="overview_desc">Description  :  </label> {{description}}
                    <br>
                    <label for="overview_table">Dimensions  :  </label> <span id="overview_dim"></span>
                    <br>
                    <label for="overview_measure">Measures  :  </label> <span id="overview_measure"></span>
                    <br>

                    <!--<p>
                        Terms and conditions: Keep your smile :)
                    </p>
                    <div id="form-step-3" role="form" data-toggle="validator">
                        <div class="form-group">
                            <label for="terms">I agree with the T&C</label>
                            <input type="checkbox" id="terms" data-error="Please accept the Terms and Conditions" required>
                            <div class="help-block with-errors"></div>
                        </div>
                    </div>-->


                </div>
            </div>
        </div>

    </form>

</div>

<!-- Include jQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<!-- Include jQuery Validator plugin -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/1000hz-bootstrap-validator/0.11.5/validator.min.js"></script>


<!-- Include SmartWizard JavaScript source -->
<script type="text/javascript" src="js/jquery.smartWizard.min.js"></script>

<script type="text/javascript">
    $(document).ready(function(){

        // Toolbar extra buttons
        var btnFinish = $('<button></button>').text('Finish')
            .addClass('btn btn-info')
            .on('click', function(){
                if( !$(this).hasClass('disabled')){
                    var elmForm = $("#myForm");
                    if(elmForm){
                        elmForm.validator('validate');
                        var elmErr = elmForm.find('.has-error');
                        if(elmErr && elmErr.length > 0){
                            alert('Oops we still have error in the form');
                            return false;
                        }else{
                            //alert('Great! we are ready to submit form');
                            elmForm.submit();
                            //Prepare to save the Cube Configuration to save in the file


                            return false;
                        }
                    }
                }
            });
        var btnCancel = $('<button></button>').text('Cancel')
            .addClass('btn btn-danger')
            .on('click', function(){
                $('#smartwizard').smartWizard("reset");
                $('#myForm').find("input, textarea").val("");
            });



        // Smart Wizard
        $('#smartwizard').smartWizard({
            selected: 0,
            theme: 'dots',
            transitionEffect:'fade',
            toolbarSettings: {toolbarPosition: 'bottom',
                toolbarExtraButtons: [btnFinish, btnCancel]
            },
            anchorSettings: {
                markDoneStep: true, // add done css
                markAllPreviousStepsAsDone: true, // When a step selected by url hash, all previous steps are marked done
                removeDoneStepOnNavigateBack: true, // While navigate back done step after active step will be cleared
                enableAnchorOnDoneStep: true // Enable/Disable the done steps navigation
            }
        });

        $("#smartwizard").on("leaveStep", function(e, anchorObject, stepNumber, stepDirection) {
            var elmForm = $("#form-step-" + stepNumber);
            // stepDirection === 'forward' :- this condition allows to do the form validation
            // only on forward navigation, that makes easy navigation on backwards still do the validation when going next
            if(stepDirection === 'forward' && elmForm){
                elmForm.validator('validate');
                var elmErr = elmForm.children('.has-error');
                if(elmErr && elmErr.length > 0){
                    // Form validation failed
                    return false;
                }
            }
            if(stepNumber == 0) {
                //alert('Entering into next step : ' + stepNumber + $('#modelName').val());
                var resultArray = [];
                //$('#tableName').children('option:not(:first)').remove();
                $.get("api/get/tables/" + $('#modelName').val(), function (data, status) {
                    //alert("Data: " + data.tableList + "\nStatus: " + status);
                    resultArray = data.tableList;
                    $.each(resultArray, function (index, value) {
                        //alert( index + ": " + value );
                        $('#tableName1')
                            .append($("<option></option>")
                                .attr("value", value)
                                .text(value));

                    });

                });
                //alert(resultArray.length) ;
            }

            if(stepNumber == 1) {
                //alert('Entering into next step : ' + stepNumber + $('#modelName').val());
                var resultArray = [];
                //$('#tableName').children('option:not(:first)').remove();
                $.get("api/get/tables/" + $('#modelName').val(), function (data, status) {
                    //alert("Data: " + data.tableList + "\nStatus: " + status);
                    resultArray = data.tableList;
                    $.each(resultArray, function (index, value) {
                        //alert( index + ": " + value );
                        $('#factTableName1')
                            .append($("<option></option>")
                                .attr("value", value)
                                .text(value));

                    });

                });
                //alert(resultArray.length) ;
            }

            if(stepNumber ==2){
                confirmDimensionMeasure();
            }

            //fetchTableName($('#modelName').val());
            return true;

        });

        $("#smartwizard").on("showStep", function(e, anchorObject, stepNumber, stepDirection) {
            // Enable finish button only on last step
            if(stepNumber == 3){
                $('.btn-finish').removeClass('disabled');
            }else{
                $('.btn-finish').addClass('disabled');
            }
        });

    });
</script>

<script type="text/javascript">
    var rowId = 1;
    var rowIdMsr = 1;
    var selectedDimension='';
    var selectedMeasure='';
    var selectedTable='';
    function addDimension(){

        rowId++;
        var html =   '<div class="form-group">'
            +'<label for="dimensionName'+rowId+'">Name:</label>'
            +'<input type="text" class="form-control" style="width:35%" name="dimensionName'+rowId+'" id="dimensionName'+rowId+'" placeholder="Dimension name">'
            //+'<div class="help-block with-errors"></div>'

            //+'<label for="tableName_'+elemId+'"'+'>Table Name:</label>'
            +'<label for="tableName'+rowId+'">Table Name:</label>'
            +   '<select class="form-control" id="tableName'+rowId+'" style="width:35%" ng-model="tableName'+rowId+'" onchange="fetchColumnNamesDimension('+rowId+')">'
            +        '<option>Select table</option>'

            +    '</select>'
            +'<label for="colName'+rowId+'">Column Name:</label>'
            +'<select class="form-control" id="colName'+rowId+'" style="width:35%" ng-model="colName'+rowId+'">'
            + '<option>Select column</option>'
            +'</select>'
            +'</div>'
            +'<br/>'
            + '<button type="button" class="btn" onclick="removeDimension()">Remove</button>';
        addElement('form-step-1', 'div', 'row-' + rowId, html);//alert(elemId)

        $.get("api/get/tables/" + $('#modelName').val(), function (data, status) {
            //alert("Data: " + data.tableList + "\nStatus: " + status);
            resultArray = data.tableList;
            $.each(resultArray, function (index, value) {
                //alert( index + ": " + value );
                $('#tableName'+rowId+'')
                    .append($("<option></option>")
                        .attr("value", value)
                        .text(value));

            });

        });

    }

    function removeDimension(){
        //alert(rowId)
        removeElement('row-' + rowId + '');
        rowId--;
        return false;
    }

    function addElement(parentId, elementTag, elementId, html) {
        // Adds an element to the document
        var p = document.getElementById(parentId);
        var newElement = document.createElement(elementTag);
        newElement.setAttribute('id', elementId);
        newElement.innerHTML = html;
        p.appendChild(newElement);
    }

    function removeElement(elementId) {
        // Removes an element from the document
        var element = document.getElementById(elementId);
        element.parentNode.removeChild(element);
    }

    function  fetchColumnNamesDimension(rowNumber){
        var selectedTable=$("#tableName"+rowNumber+" option:selected").val();
        var dbName= $("#modelName option:selected").val();
        $.get("api/get/columns/"+dbName+"/"+selectedTable, function (data, status) {
            //alert("Data: " + data.tableList + "\nStatus: " + status);
            resultArray = data.columnList;
            $.each(resultArray, function (index, value) {
                //alert( index + ": " + value );
                $('#colName'+rowId+'')
                    .append($("<option></option>")
                        .attr("value", value)
                        .text(value));

            });

        });
    }

    //Dimension dynmaic addition
    function addMeasure(){

        rowIdMsr++;
        var html =   '<div class="form-group">'
            +'<label for="measureName'+rowIdMsr+'">Name:</label>'
            +'<input type="text" class="form-control" style="width:35%" name="measureName'+rowIdMsr+'" id="measureName'+rowIdMsr+'" placeholder="Measure name">'

            +'<label for="factTableName'+rowIdMsr+'">Table Name:</label>'
            +   '<select class="form-control" id="factTableName'+rowIdMsr+'" style="width:35%" ng-model="factTableName'+rowIdMsr+'" onchange="fetchColumnNamesMeasure('+rowIdMsr+')">'
            +        '<option>Select Fact table</option>'

            +    '</select>'
            +'<label for="measureExpression'+rowIdMsr+'">Expression:</label>'
            +   '<select class="form-control" id="measureExpression'+rowIdMsr+'" style="width:35%" ng-model="measureExpression'+rowIdMsr+'">'
            +        '<option value="SUM">SUM</option>'
            +        '<option value="MAX">MAX</option>'
            +        '<option value="MIN">MIN</option>'
            +        '<option value="COUNT">COUNT</option>'
            +        '<option value="COUNT_DISTINCT">COUNT_DISTINCT</option>'
            +        '<option value="TOP_N">TOP_N</option>'
            +    '</select>'
            +'<label for="measureColName'+rowIdMsr+'">Column Name:</label>'
            +'<select class="form-control" id="measureColName'+rowIdMsr+'" style="width:35%" ng-model="measureColName'+rowIdMsr+'">'
            + '<option>Select column</option>'
            +'</select>'
            +'</div>'
            +'<br/>'
            + '<button type="button" class="btn" onclick="removeMeasure()">Remove</button>';
        addElement('form-step-2', 'div', 'mrow-' + rowIdMsr, html);//alert(elemId)

        $.get("api/get/tables/" + $('#modelName').val(), function (data, status) {
            //alert("Data: " + data.tableList + "\nStatus: " + status);
            resultArray = data.tableList;
            $.each(resultArray, function (index, value) {
                //alert( index + ": " + value );
                $('#factTableName'+rowIdMsr+'')
                    .append($("<option></option>")
                        .attr("value", value)
                        .text(value));

            });

        });

    }
    function removeMeasure(){
        //alert(rowId)
        removeElement('mrow-' + rowIdMsr + '');
        rowIdMsr--;
        return false;
    }

    function  fetchColumnNamesMeasure(rowNumber){
        var selectedTable=$("#factTableName"+rowNumber+" option:selected").val();
        var dbName= $("#modelName option:selected").val();
        $.get("api/get/columns/"+dbName+"/"+selectedTable, function (data, status) {
            //alert("Data: " + data.tableList + "\nStatus: " + status);
            resultArray = data.columnList;
            $.each(resultArray, function (index, value) {
                //alert( index + ": " + value );
                $('#measureColName'+rowIdMsr+'')
                    .append($("<option></option>")
                        .attr("value", value)
                        .text(value));

            });

        });
    }


    function confirmDimensionMeasure(){
        selectedDimension='';
        selectedMeasure='';
        selectedTable='';
        for (var i = 1; i <= rowId; i++) {
            if(i>1){
                selectedDimension+=',';
                selectedTable+=',';
            }
            //selectedDimension+= $("#tableName"+i+" option:selected").val()+'.'+$("#colName"+i+" option:selected").val();
            selectedDimension+= $("#tableName"+i+" option:selected").val()+'.'+$("#colName"+i+" option:selected").val();
            selectedTable+=$("#modelName option:selected").val()+'.'+$("#tableName"+i+" option:selected").val();
        }
        document.getElementById("overview_dim").innerHTML = selectedDimension;
        document.getElementById("capturedDimension").value=selectedDimension;
        document.getElementById("capturedTable").value=selectedTable;

        for (var j = 1; j <= rowIdMsr; j++) {

            if(j>1){
                selectedMeasure+=',';
            }

            selectedMeasure+= $("#factTableName"+j+" option:selected").val()+'.'+$("#measureColName"+j+" option:selected").val()+'-'+$("#measureExpression"+j+" option:selected").val();

        }
        document.getElementById("overview_measure").innerHTML = selectedMeasure;
        document.getElementById("capturedMeasure").value = selectedMeasure;
    }


</script>

</body>
</html>