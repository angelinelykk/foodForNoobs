//
//  AddRecipe.swift
//  testApi
//
//  Created by Max Wilcoxson on 11/28/21.
//

import SwiftUI
import AVFoundation

struct AddRecipe: View {
    @State var title = ""
    @State var amounts = [String](repeating: "", count: 1)
    @State var ingredients = [String](repeating: "", count: 1)
    @State var instructions = [String](repeating: "", count: 1)
    @State var image : UIImage! = {
        let config = UIImage.SymbolConfiguration(pointSize: 250)
        return UIImage(systemName: "photo",withConfiguration: config)!
    }()
    @State private var showPhotoLibrary = false
    @State private var takePhoto = false
    @State var hasImage = false
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                AppTitleText()
                Spacer()
                Form {
                    TextField("Title", text: self.$title)
                    HStack {
                        Image(uiImage: self.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width - 32)
                    }
                    CameraButtonsView(showPhotoLibrary: self.$showPhotoLibrary, takePhoto: self.$takePhoto)
                    IngredientsView(ingredients: self.$ingredients, amounts: self.$amounts, width: geometry.size.width)
                    InstructionsView(instructions: self.$instructions)
                    SubmitButtonView(title: self.title, image: self.image, ingredients: self.ingredients, amounts: self.amounts, instructions: self.instructions, hasImage: self.hasImage)
                }
            }.sheet(isPresented: self.$showPhotoLibrary) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image, hasImage: self.$hasImage)
            }
            .sheet(isPresented: self.$takePhoto) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image, hasImage: self.$hasImage)
            }
        }
    }
    struct CameraButtonsView : View {
        @Binding var showPhotoLibrary : Bool
        @Binding var takePhoto : Bool
        var body : some View {
            HStack(spacing: 4) {
                Button(action: {
                    requestCameraAuth() { granted in
                        if granted {
                            self.takePhoto = true
                        }
                    }
                }) {
                    TakePhoto()
                }
                Button(action: {
                    self.showPhotoLibrary = true
                }) {
                    ChoosePhoto()
                }
            }.buttonStyle(BorderlessButtonStyle())
        }
    }
    struct IngredientsView : View {
        @Binding var ingredients : [String]
        @Binding var amounts : [String]
        var width : CGFloat
        var body : some View {
            return Section(header: Text("Ingredients")) {
                List {
                ForEach((1...self.ingredients.count), id: \.self) { num in
                    HStack {
                        TextField("Amount", text: self.$amounts[num-1])
                            .frame(width: width*0.25)
                        TextField("Ingredient " + String(num), text: self.$ingredients[num-1])
                            .frame(width: width*0.75)
                    }
                }
                .onDelete(perform: delete)
                }
                HStack {
                    Spacer()
                Button(action: {
                    self.ingredients.append("")
                    self.amounts.append("")
                }) {
                    addIngredient()
                }
                Spacer()
            }
            }
        }
        func delete(at offsets: IndexSet) {
            if self.ingredients.count > 1 {
            self.ingredients.remove(atOffsets: offsets)
            self.amounts.remove(atOffsets: offsets)
            }
        }
    }
    struct InstructionsView : View {
        @Binding var instructions : [String]
        var body : some View {
            return Section(header: Text("Instructions")) {
                List {
                ForEach((1...self.instructions.count), id: \.self) { num in
                    HStack {
                        Text(String(num) + ".")
                            .padding(.trailing)
                        TextField("Instruction #" + String(num), text: self.$instructions[num-1])
                    }
                }
                .onDelete(perform: delete)
                }
                HStack {
                    Spacer()
                Button(action: {
                    self.instructions.append("")
                }) {
                    addInstruction()
                }
                    Spacer()
                }
            }
        }
        func delete(at offsets: IndexSet) {
            if self.instructions.count > 1 {
            self.instructions.remove(atOffsets: offsets)
            }
        }
    }
    struct SubmitButtonView : View {
        var title : String
        var image : UIImage
        var ingredients : [String]
        var amounts : [String]
        var instructions : [String]
        var hasImage : Bool
        @State var alert : Alert!
        @State var isPresented : Bool = false
        var body : some View {
            return HStack {
                Spacer()
            Button(action: {
                guard title != "" else {
                    self.alert = Alert(title: Text("Missing Title"), message: Text("Please add a title"))
                    self.isPresented = true
                    return
                }
                guard hasImage else {
                    self.alert = Alert(title: Text("Missing image"), message: Text("Please add an image"))
                    self.isPresented = true
                    return
                }
                let ingredientsIndex = allNotNull(array: ingredients)
                guard ingredientsIndex == -1 else {
                    self.alert = Alert(title: Text("Empty ingredient"), message: Text("Ingredient \(ingredientsIndex + 1) is empty"))
                    self.isPresented = true
                    return
                }
                let amountsIndex = allNotNull(array: amounts)
                guard amountsIndex == -1 else {
                    self.alert = Alert(title: Text("Empty amount"), message: Text("Amount \(amountsIndex + 1) is empty"))
                    self.isPresented = true
                    return
                }
                let instructionsIndex = allNotNull(array: instructions)
                guard instructionsIndex == -1 else {
                    self.alert = Alert(title: Text("Empty instruction"), message: Text("Instruction \(instructionsIndex + 1) is empty"))
                    self.isPresented = true
                    return
                }
                RecipeAPI.shared.uploadRecipe(title: self.title, amounts: self.amounts, ingredients: self.ingredients, instructions: self.instructions, image: self.image)
            }) {
                UploadRecipe()
            }
                Spacer()
            }.alert(isPresented: self.$isPresented) {
                self.alert
            }
        }
    }
    struct AppTitleText : View {
        var body: some View {
            return Text("Food For Noobs")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
        }
    }
    struct TakePhoto : View {
        var body: some View {
            return Text("Take Photo")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
                .padding()
                .frame(width: UIScreen.main.bounds.size.width / 2 - 18, height: 50)
                .background(Color.green)
                .cornerRadius(15.0)
        }
    }
    struct ChoosePhoto : View {
        var body: some View {
            return Text("Choose Photo")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
                .padding()
                .frame(width: UIScreen.main.bounds.size.width / 2 - 18, height: 50)
                .background(Color.green)
                .cornerRadius(15.0)
        }
    }
    struct addIngredient : View {
        var body: some View {
            return Text("Add Ingredient")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: UIScreen.main.bounds.size.width / 2, height: 50)
                .background(Color.green)
                .cornerRadius(15.0)
        }
    }
    struct addInstruction : View {
        var body: some View {
            return Text("Add Instruction")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: UIScreen.main.bounds.size.width / 2, height: 50)
                .background(Color.green)
                .cornerRadius(15.0)
        }
    }
    struct UploadRecipe : View {
        var body: some View {
            return Text("Upload Recipe")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: UIScreen.main.bounds.size.width / 2, height: 50)
                .background(Color.green)
                .cornerRadius(15.0)
        }
    }
}

func allNotNull(array: [String]) -> Int {
    for i in 0..<array.count {
        if array[i] == "" {
            return i
        }
    }
    return -1
}

func requestCameraAuth(completion: ((Bool)->Void)?) {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
        completion?(true)
    case .notDetermined:
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
            completion?(granted)
        })
    case .restricted:
        completion?(false)
    case .denied:
        completion?(false)
    }
}
struct ImagePicker : UIViewControllerRepresentable {
    //Credit to https://www.appcoda.com/swiftui-camera-photo-library/ for help with understanding how to do an imagePicker in swiftui using UIViewControllerRepresentable
    var sourceType : UIImagePickerController.SourceType
    @Binding var selectedImage : UIImage!
    @Environment(\.presentationMode) private var presentationMode
    @Binding var hasImage : Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    final class Coordinator : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent : ImagePicker
        init(parent: ImagePicker) {
            self.parent = parent
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                parent.hasImage = true
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}



struct AddRecipe_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipe()
    }
}
