//
//  ContentView.swift
//  Shared
//
//  Created by Frank Lopez on 2022/01/01.
//

import SwiftUI
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct DefaultValues {
    static let UserId = ""
}

struct ContentView: View {
    var body: some View {
        if GetCurrentUser() != "" {
            MainView()
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//login and main views

struct LoginView: View {
    var body: some View {
        Text("A place to keep your stuff in order.").padding(4)
        
        Button {
            //CreateUser(first_name: "frank", last_name: "lopez", first_name_kana: "フランク", last_name_kana: "ロペス", mail_address: "spiccanelforzo@outlook.com", password: "Admin123", password_confirmation: "Admin123")
            print("Create account")
        } label: {
            Text("Create account").padding(4)
        }
        //.overlay(RoundedRectangle(cornerRadius: 4.0).stroke(lineWidth: 2.0))
        
        Button {
            print("Sign in")
        } label: {
            Text("Sign in").padding(4)
        }
        //.overlay(RoundedRectangle(cornerRadius: 4.0).stroke(lineWidth: 2.0))
    }
}

struct MainView: View {
    var body: some View {
        Text("A place to keep your stuff in order.").padding()
    }
}

func GetCurrentUser() -> String {
    let defaults = UserDefaults.standard
    let UserId = defaults.string(forKey: DefaultValues.UserId)
    if UserId != nil {
        return UserId!
    } else {
        return ""
    }
}

func CreateUser(first_name:String, last_name:String, first_name_kana:String, last_name_kana:String, mail_address:String, password:String, password_confirmation:String) {
    var semaphore = DispatchSemaphore (value: 0)

    let parameters = "{\n    \"first_name\":\""+first_name+"\",\n    \"last_name\":\""+last_name+"\",\n    \"first_name_kana\":\""+first_name_kana+"\",\n    \"last_name_kana\":\""+last_name_kana+"\",\n    \"mail_address\":\""+mail_address+"\",\n    \"password\":\""+password+"\",\n    \"password_confirmation\":\""+password_confirmation+"\"\n}"
    let postData = parameters.data(using: .utf8)

    var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/api/users")!,timeoutInterval: Double.infinity)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    request.httpMethod = "POST"
    request.httpBody = postData

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else {
        print(String(describing: error))
        semaphore.signal()
        return
      }
      print(String(data: data, encoding: .utf8)!)
      semaphore.signal()
    }

    task.resume()
    semaphore.wait()
}
