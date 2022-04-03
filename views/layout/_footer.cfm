<cfoutput>

<footer id="footer">
	<div class="footer-social">
		<div class="container">
			<div class="row">
				<div class="col-md-4">
					<div class="social">
						<cfif getModuleSettings( 'cbCommerce', 'socialFB', '' ) is not "">
							<span class="fa-stack fa-1x">
								<a href="#getModuleSettings( 'cbCommerce', 'socialFB' )#" target="_blank" >
									<span class="sr-only">Visit our Facebook page</span>
									<span class="fa fa-facebook-square fa-stack-2x"></span>
								</a>
							</span>
						</cfif>
						<cfif getModuleSettings( 'cbCommerce', 'socialT', '' ) is not "">
							<span class="fa-stack fa-1x">
								<a href="#getModuleSettings( 'cbCommerce', 'socialT' )#" target="_blank" >
									<span class="sr-only">Twitter</span>
									<span class="fa fa-twitter fa-stack-2x"></span>
								</a>
							</span>
						</cfif>
						<cfif getModuleSettings( 'cbCommerce', 'socialGP', '' ) is not "" >
							<span class="fa-stack fa-1x">
								<a href="#getModuleSettings( 'cbCommerce', 'socialGP' )#" target="_blank" >
									<span class="sr-only">Google+</span>
									<span class="fa fa-google-plus fa-stack-2x"></span>
								</a>
							</span>
						</cfif>
						<cfif getModuleSettings( 'cbCommerce', 'socialIG', '' ) is not "">
							<span class="fa-stack fa-1x">
								<a href="#getModuleSettings( 'cbCommerce', 'socialIG' )#" target="_blank" >
									<span class="sr-only">Instagram</span>
									<span class="fa fa-instagram fa-stack-2x"></span>
								</a>
							</span>
						</cfif>
						<cfif getModuleSettings( 'cbCommerce', 'socialYT', '' ) is not "">
							<span class="fa-stack fa-1x">
								<a href="#getModuleSettings( 'cbCommerce', 'socialYT' )#" target="_blank" >
									<span class="sr-only">YouTube</span>
									<span class="fa fa-youtube fa-stack-2x"></span>
								</a>
							</span>
						</cfif>
						<cfif getModuleSettings( 'cbCommerce', 'socialSL', '' ) is not "">
							<span class="fa-stack fa-1x">
								<a href="#getModuleSettings( 'cbCommerce', 'socialSL' )#" target="_blank" >
									<span class="sr-only">Slack</span>
									<span class="fa fa-slack fa-stack-2x"></span>
								</a>
							</span>
						</cfif>
						<cfif getModuleSettings( 'cbCommerce', 'socialGH', '' ) is not "">
							<span class="fa-stack fa-1x">
								<a href="#getModuleSettings( 'cbCommerce', 'socialGH' )#" target="_blank" >
									<span class="sr-only">GitHub</span>
									<span class="fa fa-github fa-stack-2x"></span>
								</a>
							</span>
						</cfif>
					</div>
				</div>
				<div class="col-md-8">
				</div>
			</div>
		</div>
	</div>
	<div class="footer-information">
    	<div class="container">
    		<div class="row">
	    		<div class="col-md-6">
	    			<div class="col-md-12 footerInfoBox">
	    				#getModuleSettings( 'cbCommerce', 'footerInfoBox', '' )#
	    			</div>
	    		</div>
	    		<div class="col-md-6">

	    			<div
						class="block-form box-border wow fadeInLeft animated"
						data-wow-duration="1s">

						<h3>Send Us A <span class="heading-highlight">Message</span></h3>

		    			<!--- contact form --->
		    			<contact-form message-rows="10"></contact-form>

		    		</div>

	    		</div>
	    	</div>
        </div>
    </div>

	<div class="footer-copy">
		<div class="container">
			<div class="col-md-4">
				#getModuleSettings( 'cbCommerce', 'footerBox', '' )#
			</div>
			<div class="col-md-4 text-center">
				#getModuleSettings( 'cbCommerce', 'footerBox2', '' )#
			</div>
			<div class="col-md-4 text-right">
				<p class="text-muted">Copyright &copy; #getModuleSettings( 'cbCommerce', 'siteName', 'Ortus Solutions' )#.  All rights reserved.</p>
			</div>
		</div>
	</div>
</footer>
</cfoutput>