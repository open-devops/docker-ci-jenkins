pipeline {
  agent any
  stages {
    stage('Initialize') {
      steps {
        sh 'echo "Initilize Step"'
      }
    }
    stage('Build') {
      steps {
        ws(dir: 'sample') {
          sh 'echo "call mvn springboot:run"'
        }
        
      }
    }
    stage('Test') {
      steps {
        parallel(
          "Test": {
            echo 'test'
            
          },
          "Angular Test": {
            echo 'FrontEnd'
            
          },
          "Spring Test": {
            echo 'Spring'
            
          }
        )
      }
    }
    stage('Deploy') {
      steps {
        echo 'deploy'
      }
    }
  }
}