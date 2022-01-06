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
            SplashView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//app views

struct SplashView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("A place to keep your stuff in order.").padding(2)
                
                NavigationLink(destination: CreateAccountView()) {
                    Text("Create account")
                }.padding(2)
                
                NavigationLink(destination: SignInView()) {
                    Text("Sign in")
                }.padding(2)
            }
        }
    }
}

struct MainView: View {
    var body: some View {
        Text("Main view.").padding()
    }
}

struct CreateAccountView: View {
    @State private var first_name: String = ""
    @State private var last_name: String = ""
    @State private var first_name_kana: String = ""
    @State private var last_name_kana: String = ""
    @State private var mail_address: String = ""
    @State private var password: String = ""
    @State private var password_confirmation: String = ""
    
    var body: some View {
        NavigationView {
            VStack(
                alignment: .center, spacing: 10
            ) {
                Text("Please enter your details below.")
                
                TextField(
                    "first name",
                    text: $first_name
                ).frame(width: 200)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .fixedSize(horizontal: true, vertical: false)
                
                TextField(
                    "last name",
                    text: $last_name
                ).frame(width: 200)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .fixedSize(horizontal: true, vertical: false)
                
                TextField(
                    "first name kana",
                    text: $first_name_kana
                ).frame(width: 200)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .fixedSize(horizontal: true, vertical: false)
                
                TextField(
                    "last name kana",
                    text: $last_name_kana
                ).frame(width: 200)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .fixedSize(horizontal: true, vertical: false)
                
                TextField(
                    "mail address",
                    text: $mail_address
                ).frame(width: 200)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .fixedSize(horizontal: true, vertical: false)
                
                SecureField(
                    "password",
                    text: $password
                ).frame(width: 200)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .fixedSize(horizontal: true, vertical: false)
                
                SecureField(
                    "password confirmation",
                    text: $password_confirmation
                ).frame(width: 200)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .fixedSize(horizontal: true, vertical: false)
                
                Button(action: {
                    print("hey!")
                }) {
                    Text("Create account")
                        .fontWeight(.bold)
                        .padding(8)
                        .background(Color.purple)
                        .foregroundColor(Color.white)
                        .cornerRadius(8)
                        .padding(.bottom, 20)
                }
            }
        }.navigationBarTitle("Create account")
    }
}

struct SignInView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Sign in view.").padding()
            }
        }.navigationBarTitle("Sign in")
//        .navigationBarHidden(true)
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
