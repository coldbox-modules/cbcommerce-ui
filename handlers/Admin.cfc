component extends="coldbox.system.EventHandler"{

    function index( event, rc, prc ){
        event.setLayout( "Admin" );
    }

    function app( event, rc, prc ){
        event.setLayout( "Admin" );
    }

}
