<cfoutput>
	<cfif prc.isContentBoxContext>
		<cfset prc.headerMainNav = cb.themeSetting( 'headerMainNav', true )>
		<cfset prc.globalData[ "rootMenu" ] = cb.menu( slug="main-nav", type="data" )/>
	</cfif>

	<header id="header">
		<!--- header-top-row --->
		<div class="header-top-row">
			<div class="container-fluid">
				<div class="row">
					<div class="col-lg-3 hidden-xs hidden-sm">
                        <div class="top-welcome">
							<!--- logo --->
							<div class="col-lg-3">
								<cfif prc.isContentBoxContext && cb.themeSetting( 'headerLogo' ) is "">
									<a href="#cb.linkHome()#" class="navbar-brand" title="#cb.siteTagLine()#" data-toggle="tooltip">
										<strong>#cb.siteName()#</strong>
									</a>
								<cfelseif prc.isContentBoxContext>
									<a href="#cb.linkHome()#" class="header-logo brand-img" title="#cb.siteTagLine()#" data-toggle="tooltip">
										<img id="logo-default" src="#cb.themeSetting( 'headerLogo' )#" alt="#cb.siteName()#" class="hidden-xs hidden-sm img-responsive">
										<!--- to display on viewports less than 992px --->
										<img id="logo-alt" src="#cb.themeSetting( 'alternateLogo' )#" alt="#cb.siteName()#" class="hidden-md hidden-lg img-responsive">
									</a>
								<cfelseif len( getModuleSettings( "cbcommerce-ui", "headerLogo", "" ) )>
									<a href="/#event.getModuleEntryPoint( "cbcommerce-ui" )#" class="header-logo brand-img" title="" data-toggle="tooltip">
										<img id="logo-default" height="50px" src="#event.getModuleRoot( "cbcommerce-ui" )#/#getModuleSettings( "cbcommerce-ui", "headerLogo" )#" alt="#getModuleSettings( "cbcommerce-ui", "storeName" )#" class="hidden-xs hidden-sm img-responsive">
									</a>
								</cfif>
							</div>
							<cfif prc.isContentBoxContext>
								#cb.themeSetting( 'headerText', 'Welcome to our Store' )#
							<cfelse>
								#getModuleSettings( "cbcommerce-ui", "headerText", "" )#
							</cfif>
                        </div>
                    </div>
					<div class="col-lg-6">
						<div class="top-search-form">
							<form id="search-form" name="searchForm" method="get" action="/store/product">
								<div class="input-group">
									<input type="text" class="form-control" placeholder="Search" name="search" id="searchInput" value="#event.getValue( "search", "" )#">
									<span class="input-group-btn">
										<button type="submit" class="btn btn-default"><i class="fa fa-search"></i></button>
									</span>
								</div>
							</form>
						</div>
					</div>
                    <div class="col-lg-3">
						<ul class="pull-right secondary-nav">
                        	<!--- header-cart menu --->
                        	<li id="cart-menu" class="secondary-nav-item pull-right">
                        		<a href="/store/shopping-cart" class="secondary-menu-title">
                        			<nav-cart></nav-cart>
                        		</a>
                        	</li>
                        	<!--- header-account menu --->
                            <li id="account-menu" class="secondary-nav-item pull-right">
                                <nav-user></nav-user>
                            </li>
                        </ul>
                    </div>
				</div>
			</div>
		</div>
	</header>
</cfoutput>