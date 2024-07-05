pipeline {
  agent { label ('ec2-fleet-nodejs16')}
  stages {
      stage('Pre Deployment') {
        steps {
          slackSend (
          channel: "nals-mobile-codebase-dev-notifier",
          color: '#FFFF00',
          message: "Starting Job:    » ${env.JOB_NAME} [${env.BUILD_NUMBER}]\nBranch     » ${env.GIT_BRANCH}",
          teamDomain: 'nalsdn',
          tokenCredentialId: 'nalsdn-nft-slack'
          )
          script {
            env.GIT_TAG = sh(returnStdout: true, script: 'git tag --points-at ${GIT_COMMIT} || :').trim()
            env.GIT_COMMIT_MSG = sh(script: 'git log -1 --pretty=%B ${GIT_COMMIT}', returnStdout: true).trim()
          }
        }
      }
      stage('PR-check') {
        when { anyOf { branch 'PR-*'} }
          agent {
            docker {
              image 'ghcr.io/cirruslabs/flutter:3.19.1'
              reuseNode true
              args '-u root'
            }
          }
          steps {
          bitbucketStatusNotify(buildState: 'INPROGRESS')
           sh '''
           flutter doctor -v
           make sync
           make check_pubs
           make te
           make fm
           make lint
           '''
        }
    }
  }
  post {
    success {
      slackSend (
        channel: "nals-mobile-codebase-dev-notifier",
        color: '#00FF00',
        message: "Status   » SUCCESS\nJob       » ${env.JOB_NAME} [${env.BUILD_NUMBER}]\nBranch     » ${env.GIT_BRANCH}\n    » ${env.GIT_COMMIT} [${GIT_COMMIT_MSG}]",
        teamDomain: 'nalsdn',
        tokenCredentialId: 'nalsdn-nft-slack'
        )
      bitbucketStatusNotify(buildState: 'SUCCESSFUL')
    }
    failure {
      slackSend (
        channel: "nals-mobile-codebase-dev-notifier",
        color: '#FF0000',
        message: "Status   » FAILED\nJob       » ${env.JOB_NAME} [${env.BUILD_NUMBER}]\nBranch     » ${env.GIT_BRANCH}\n    » ${env.GIT_COMMIT} [${GIT_COMMIT_MSG}]",
        teamDomain: 'nalsdn',
        tokenCredentialId: 'nalsdn-nft-slack'
        )
      bitbucketStatusNotify(buildState: 'FAILED')
    }
  }
}