#!groovy
import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey
import hudson.plugind.sshslaves.*

def createSSHCredentials(String credentialsId, String username) {

    domain = Domain.global()
    store = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

    credentials = new BasicSSHUserPrivateKey(
            CredentialsScope.GLOBAL,
            credentialsId,
            username,
            new BasicSSHUserPrivateKey.UsersPrivateKeySource(),
            "",
            ""
    )
    store.addCredentials(domain, credentials)
}

// Usage example
createSSHCredentials("jenkins-workers", "ec2-user")