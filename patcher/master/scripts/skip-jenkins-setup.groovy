#!groovy
import jenkins.model.*
import hudston.util.*
import jenkins.install.*

def instance = Jenkins.getInstance()

instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)