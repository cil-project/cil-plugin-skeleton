(* A sample CIL plugin *)

(* API changes from 1.7.3 are marked with XXX below *)

open Cil
open Feature (* XXX you need to open the Feature module *)

let counter = ref 0

class countCalls = object(self)
  inherit nopCilVisitor

  method vinst = function
  | Call _ -> incr counter; DoChildren
  | _ -> DoChildren
end

(* XXX Cil.featureDescr is now Feature.t *)
let feature : Feature.t = {
    fd_name = "countCalls";
    fd_enabled = false; (* XXX fd_enabled is now a bool, not a bool ref anymore. *)
    fd_description = "count and display the number of function calls";
    fd_extraopt = [];
    fd_doit = (function f ->
      visitCilFileSameGlobals (new countCalls) f;
      Errormsg.log "%s contains %d function calls\n" f.fileName !counter;
    );
    fd_post_check = true;
  } 

(* XXX you need to register each feature using Feature.register. *)
let () = Feature.register feature
