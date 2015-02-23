
class pubsub

	# --- list of topics in the pubsub + handle counter
	topics: {}
	handle: 0
	
	# --- subscribes a function to a particular topic
	# --- the attribute "create" precise that we want to create the topic if it doesn't exist
	subscribe: (topic, callback, create) ->
		if not @topics[topic] and create == true
			@topics[topic] = []
		
		if @topics[topic]
			myHandle = ++@handle
			@topics[topic].push
					"callback": callback, "handle": myHandle
			myHandle
		else
			false
	
	# --- removes a subscription from pubsub
	unsubscribe: (topic, handle) ->
		if @topics[topic]
			list = []
			list.push i for t, i in @topics[topic] when t.handle == handle
			@topics[topic].splice l, 1 for l in list
			true
		else
			false
	
	# --- publish an object into a topic
	publish: (topic, object) ->
		if @topics[topic]
			t.callback(object) for t in @topics[topic]
			true
		else
			false
			
	# --- check if a topic already exists
	topicExists: (topic) ->
		if @topics[topic]
			true
		else
			false
			