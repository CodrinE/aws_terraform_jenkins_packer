#!groovy
import hudson.security.csrf.DefaultCrumbIssuer
import jenkins.model.Jenkins

if(!Jenkins.instance.isQuietingDown()) {
    def instance = Jenkins.instance
    if(instance.getCrumbIssuer() == null) {
        instance.setCrumbIssuer(new DefaultCrumbIssuer(true))
        instance.save()
        println ' Enabled CSRF Protection.'
    }
    else {
        println 'CSRF Protection already configured.'
    }
}
else {
    println "Configure CSRF protection SKIPPED."
}