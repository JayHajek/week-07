if ! grep -q aws_access_key_id ~/.aws/config; then
	if ! grep -q aws_access_key_id ~/.aws/credentials; then
		tput setaf 1; echo "AWS config not found or CLI not installed. Please run \"aws configure\"." && tput sgr0
		exit 1
		
if [ $# -eq 0 ]; then
	scriptname=`bas "$0"`
	echo "Usage: ./$scriptname profile"
	echo "Where profile is the AWS CLI profile name"
	echo "Using default profile"
	echo
	profile=default
else
	profile=$1
# Generate JSON based on two listeners
	if [ "$NumListeners" -eq "2" ]; then
		if [ "$HTTPS" = "true" ]; then
			json='{
				"LoadBalancerName": "'$LoadBalancerName'",
				"Listeners": [
				{
					"Protocol": "'$Protocol'",
					"LoadBalancerPort": '$LoadBalancerPort',
					"InstanceProtocol": "'$InstanceProtocol'",
					"InstancePort": '$InstancePort',
					"SSLCertificateId": "'$SSLCertificateId'"
				},
				{
					"Protocol": "'$Protocol2'",
					"LoadBalancerPort": '$LoadBalancerPort2',
					"InstanceProtocol": "'$InstanceProtocol2'",
					"InstancePort": '$InstancePort2'
				}
				],
				"Subnets": '$Subnets',
				"SecurityGroups": '$SecurityGroups',
				"Scheme": "'$Scheme'"
			}' # > output.json
		else
			json='{
				"LoadBalancerName": "'$LoadBalancerName'",
				"Listeners": [
				{
					"Protocol": "'$Protocol'",
					"LoadBalancerPort": '$LoadBalancerPort',
					"InstanceProtocol": "'$InstanceProtocol'",
					"InstancePort": '$InstancePort'
				},
				{
					"Protocol": "'$Protocol2'",
					"LoadBalancerPort": '$LoadBalancerPort2',
					"InstanceProtocol": "'$InstanceProtocol2'",
					"InstancePort": '$InstancePort2'
				}
				],
				"Subnets": '$Subnets',
				"SecurityGroups": '$SecurityGroups',
				"Scheme": "'$Scheme'"
			}' 
		CreateLoadBalancer=$(aws elb create-load-balancer --cli-input-json "$json" --profile $profile 2>&1)
	if ! echo "$CreateLoadBalancer" | grep -qw "DNSName"; then
		fail "$CreateLoadBalancer"
	else
		echo "$CreateLoadBalancer" | jq .
		Completed
	# Register Instances with ELB
	if [ "$RegisterInstances" = "true" ]; then

		HorizontalRule
		echo "Registering Instances with New ELB"
		HorizontalRule
		echo

		# Store Instances as JSON
		json1='{
		    "LoadBalancerName": "'$LoadBalancerName'",
		    "Instances": '$Instances'
		}' # > output1.json

		# json1=$(cat output1.json)

		# Register Instances with ELB
		RegisterInstances=$(aws elb register-instances-with-load-balancer --cli-input-json "$json1" --profile $profile 2>&1)
		if ! echo "$RegisterInstances" | grep -qw "Instances"; then
			fail "$RegisterInstances"
		else
			echo "$RegisterInstances" | jq .
			Completed
		# Configure Attributes from JSON
		ConfigureAttributes=$(aws elb modify-load-balancer-attributes --cli-input-json "$json3" --profile $profile 2>&1)
		if ! echo "$ConfigureAttributes" | grep -qw "LoadBalancerAttributes"; then
			fail "$ConfigureAttributes"
		else
			echo "$ConfigureAttributes" | jq.Completed
		
