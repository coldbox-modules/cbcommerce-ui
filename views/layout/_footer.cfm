<cfoutput>

<footer id="footer">
	<div class="footer-information">
    	<div class="container">
    		<div class="row">
	    		<div class="col-lg-6">
	    			<div class="col-lg-12 footerInfoBox">
	    				#getModuleSettings( 'cbcommerce-ui', 'footerInfoBox', '' )#
						<div class="social text-center">
							<cfif getModuleSettings( 'cbcommerce-ui', 'socialFB', '' ) is not "">
								<span class="fa-stack fa-1x">
									<a href="#getModuleSettings( 'cbcommerce-ui', 'socialFB' )#" target="_blank" >
										<span class="sr-only">Visit our Facebook page</span>
										<span class="fab fa-facebook-square fa-stack-2x"></span>
									</a>
								</span>
							</cfif>
							<cfif getModuleSettings( 'cbcommerce-ui', 'socialT', '' ) is not "">
								<span class="fa-stack fa-1x">
									<a href="#getModuleSettings( 'cbcommerce-ui', 'socialT' )#" target="_blank" >
										<span class="sr-only">Twitter</span>
										<span class="fab fa-twitter fa-stack-2x"></span>
									</a>
								</span>
							</cfif>
							<cfif getModuleSettings( 'cbcommerce-ui', 'socialGP', '' ) is not "" >
								<span class="fa-stack fa-1x">
									<a href="#getModuleSettings( 'cbcommerce-ui', 'socialGP' )#" target="_blank" >
										<span class="sr-only">Google+</span>
										<span class="fab fa-google-plus fa-stack-2x"></span>
									</a>
								</span>
							</cfif>
							<cfif getModuleSettings( 'cbcommerce-ui', 'socialIG', '' ) is not "">
								<span class="fa-stack fa-1x">
									<a href="#getModuleSettings( 'cbcommerce-ui', 'socialIG' )#" target="_blank" >
										<span class="sr-only">Instagram</span>
										<span class="fab fa-instagram fa-stack-2x"></span>
									</a>
								</span>
							</cfif>
							<cfif getModuleSettings( 'cbcommerce-ui', 'socialYT', '' ) is not "">
								<span class="fa-stack fa-1x">
									<a href="#getModuleSettings( 'cbcommerce-ui', 'socialYT' )#" target="_blank" >
										<span class="sr-only">YouTube</span>
										<span class="fab fa-youtube fa-stack-2x"></span>
									</a>
								</span>
							</cfif>
							<cfif getModuleSettings( 'cbcommerce-ui', 'socialSL', '' ) is not "">
								<span class="fa-stack fa-1x">
									<a href="#getModuleSettings( 'cbcommerce-ui', 'socialSL' )#" target="_blank" >
										<span class="sr-only">Slack</span>
										<span class="fab fa-slack fa-stack-2x"></span>
									</a>
								</span>
							</cfif>
							<cfif getModuleSettings( 'cbcommerce-ui', 'socialGH', '' ) is not "">
								<span class="fa-stack fa-1x">
									<a href="#getModuleSettings( 'cbcommerce-ui', 'socialGH' )#" target="_blank" >
										<span class="sr-only">GitHub</span>
										<span class="fab fa-github fa-stack-2x"></span>
									</a>
								</span>
							</cfif>
						</div>
	    			</div>
	    		</div>
	    		<div class="col-lg-6">

	    			<div
						class="block-form box-border wow fadeInLeft animated"
						data-wow-duration="1s"
					>

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
			<div class="col-lg-4">
				#getModuleSettings( 'cbcommerce-ui', 'footerBox', '' )#
			</div>
			<div class="col-lg-4 text-center">
				#getModuleSettings( 'cbcommerce-ui', 'footerBox2', '' )#
			</div>
			<div class="col-lg-4 text-right">
				<p class="text-muted">Copyright &copy; #getModuleSettings( 'cbcommerce-ui', 'siteName', 'Ortus Solutions' )#.  All rights reserved.</p>
			</div>
		</div>
	</div>
</footer>
</cfoutput>