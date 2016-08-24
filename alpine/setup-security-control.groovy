#!groovy
import hudson.security.*
import jenkins.model.*

def instance = Jenkins.getInstance()

def adminUID = System.getenv("JENKINS_ADMIN_USER")
def adminPWD = System.getenv("JENKINS_ADMIN_PASSWORD")

println "--> Checking if security has been set already"

if (!instance.isUseSecurity()) {
    println "--> creating jenkins local admin user"

    def hudsonRealm = new HudsonPrivateSecurityRealm(false)
    hudsonRealm.createAccount(adminUID, adminPWD)
    instance.setSecurityRealm(hudsonRealm)

    def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
    instance.setAuthorizationStrategy(strategy)
    instance.save()
}