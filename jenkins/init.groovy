import jenkins.model.*
import hudson.security.*
import jenkins.security.*
import hudson.model.*
import org.jenkinsci.plugins.plaincredentials.impl.*
import org.jenkinsci.plugins.plaincredentials.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*

def instance = Jenkins.getInstance()

// Disable security initially (configure after first login)
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)

instance.save()
