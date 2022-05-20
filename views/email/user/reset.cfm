<cfoutput>
    #renderView( view="email/inc/open", module="cbcommerce-ui" )#
    <p>Your request to reset your password has been received. Please follow the link below to login and change your password.</p>
    <p><a href="#cb.linkHome()#store/account/reset/#prc.user.getResetToken()#">#cb.linkHome()#store/account/reset/#prc.user.getResetToken()#</a></p>
    #renderView( view="email/inc/close", module="cbcommerce-ui" )#
</cfoutput>