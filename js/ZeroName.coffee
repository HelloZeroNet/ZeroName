class ZeroName extends ZeroFrame
	init: ->
		@log "inited!"
		$(".link-register a").on "click", ->
			$(".block-register").toggleClass("visible")

	# Wrapper websocket connection ready
	onOpenWebsocket: (e) =>
		@updateDomains()


	updateDomains: ->
		@cmd "fileQuery", ["data/names.json", ""], (res) =>
			$(".domain:not(.template)").remove()
			for domain, address of res[0]
				if domain == "inner_path" then continue
				elem = $(".domain.template").clone().removeClass("template").appendTo(".domains")
				@applyDomainData(elem, domain, address)
			$(".domains").css("opacity", 1)


	applyDomainData: (elem, domain, address) ->
		$(".name a", elem).text(domain).attr("href", "/"+domain)
		$(".address a", elem).text(address).attr("href", "/"+address)
		$(".network a", elem).attr("href", "http://namecha.in/name/d/"+domain.replace(/^.*\.([^\.]+)\.bit/, "$1").replace(".bit", ""))


	# Route incoming requests
	route: (cmd, message) ->
		if cmd == "setSiteInfo" # Site updated
			@actionSetSiteInfo(message)
		else
			@log "Unknown command", message


	# Siteinfo changed
	actionSetSiteInfo: (res) =>
		site_info = res.params
		if site_info.event and site_info.event[0] == "file_done" and site_info.event[1] == "data/names.json" # Domain list changed
			@updateDomains()


window.zero_name = new ZeroName()