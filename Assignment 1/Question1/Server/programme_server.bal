import ballerina/http;

service /programmes on new http:Listener(8080) {

    // Resource to add a new programme
    resource function post addProgramme(@http:Payload Programme newProgramme) returns Programme|ConflictError {
        if (programmeTable.hasKey(newProgramme.code)) {
            return {
                body: {
                    errmsg: "Programme code already exists"
                }
            };
        } else {
            programmeTable.add(newProgramme);
            return newProgramme;
        }
    }

    // Resource to retrieve a list of all programmes
    resource function get listProgrammes() returns Programme[] {
        return programmeTable.toArray();
    }

}

public type Programme record {| 
    readonly string code;
    string nqfLevel;
    string faculty;
    string department;
    string title;
    string registrationDate;
    Course[] courses;
|};

public type Course record {| 
    string name;
    string code;
    string nqfLevel;
|};

// In-memory table to store programmes
public final table<Programme> key(code) programmeTable = table [];

// Error types
public type ConflictError record {| 
    *http:Conflict;
    ErrorMsg body;
|};

public type ErrorMsg record {| 
    string errmsg;
|};

public type NotFoundError record {| 
    *http:NotFound;
    ErrorMsg body;
|};
