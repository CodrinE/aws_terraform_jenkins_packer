#!groovy
import jenkins.model.Jenkins

Jenkins jenkins = Jenkins.getInstance()

// disable Jenkins CLI
jenkins.CLI.get().setEnabled(false)

// save current Jenkins state to disk
jenkins.save()