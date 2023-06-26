import SwiftUI

struct OnMyBodyView: View {
    @AppStorage("items") var itemsData: Data = Data()
    @State private var isShowingAddItemView = false
    @State private var newItemName = ""
    @State private var newItemColor = Color.gray
    @State private var newItemImage: UIImage? = nil
    @Binding var itemsCount: Int
    @State private var items: [Item] = []
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView{
            ZStack{
                VStack (alignment: .leading) {
                    Image("OnMyBodyCoverPage")
                        .resizable()
                        .frame(height: 175)
                        .frame(maxWidth: .infinity)
                    HStack {
                        Image(systemName: "applewatch")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 22)
                            .foregroundColor(Color("Text"))
                        Text("What’s On My Body?")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Text"))
                    }.padding([.top, .leading], 20)
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(items, id: \.id) { item in
                                RectangleView(item: item, items: $items)
                            }
                        }
                        .padding()
                    }
                }
                .onAppear {
                    loadItems()
                    updateItemCount()
                }
                .onDisappear {
                    saveItems()
                }
                PlusButton(action: {
                    isShowingAddItemView = true
                })
                .sheet(isPresented: $isShowingAddItemView) {
                    AddItemView(
                        isShowing: $isShowingAddItemView,
                        itemName: $newItemName,
                        itemColor: $newItemColor,
                        itemImage: $newItemImage,
                        items: $items,
                        itemsCount: $itemsCount,
                        completion: { itemName in
                            newItemName = itemName
                            updateItemCount()
                        }
                    )
                }
            }
            .ignoresSafeArea()
            .background(.white)
            
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading){
//                    Button{
//                        dismiss()
//                    }label:{
//                        Image(systemName: "chevron.backward.circle.fill")
//                            .foregroundColor(Color(.white))
//                            .shadow(radius: 4, x: 0, y:2)
//                    }
//                }
//            }
        }
    }
    
    func saveItems() {
        do {
            let encodedData = try JSONEncoder().encode(items)
            itemsData = encodedData
            updateItemCount()
        } catch {
            print("Error saving items: \(error.localizedDescription)")
        }
    }
    
    func loadItems() {
        do {
            let decodedItems = try JSONDecoder().decode([Item].self, from: itemsData)
            items = decodedItems
            updateItemCount()
        } catch {
            print("Error loading items: \(error.localizedDescription)")
        }
    }
    
    func updateItemCount() {
        itemsCount = items.count
    }
}

struct AddItemView: View {
    @Binding var isShowing: Bool
    @Binding var itemName: String
    @Binding var itemColor: Color
    @Binding var itemImage: UIImage?
    @Binding var items: [Item]
    @Binding var itemsCount: Int
    
    
    //untuk reset nama item
    var completion: (String) -> Void
    @State private var itemNameInput: String = "Item's Name"
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showImageSourceActionSheet = false
    
    @State var toggleIsOn: Bool = true
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack (alignment: .leading, spacing: 20) {
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 330, height: 230)
                            .foregroundColor(itemColor)
                        if toggleIsOn == true {
                            Image(systemName: "photo.fill.on.rectangle.fill")
                                .resizable()
                                .foregroundColor(.white)
                                .scaledToFit()
                                .frame(width: 80)
                            if isPhotoSelected {
                                if let image = itemImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 330, height: 230)
                                        .overlay(RoundedRectangle(cornerRadius: 15) .stroke(Color.gray, lineWidth: 5))
                                        .background(Color("Text"))
                                        .cornerRadius(15)
                                }
                            }
                        }
                    }
                    
                    Text("Item Name")
                        .foregroundColor(.black)
                        .padding(.bottom, -10)
                    TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: $itemNameInput)
                        .foregroundColor(.black)
                        .background(Color("Field"))
                        .padding(.horizontal)
                        .frame(width: 330, height: 32)
                        .overlay(RoundedRectangle(cornerRadius: 10) .stroke(Color.gray, lineWidth: 0))
                        .background(Color("Field"))
                        .cornerRadius(10)
                    
                    Toggle(isOn: $toggleIsOn,
                           label: {
                        Text("Use Picture")
                            .foregroundColor(.black)
                    }).toggleStyle(SwitchToggleStyle(tint: .green))
                        .frame(width: 330)
                    if toggleIsOn == false{
                        ColorPicker("Pick a Color", selection:$itemColor)
                            .frame(width: 330)
                            .foregroundColor(.black)
                    }else{
                        Button(action: {
                            showImageSourceActionSheet = true
                            toggleIsOn = true
                        },label :{
                            HStack{
                                Image(systemName: "photo.fill.on.rectangle.fill")
                                Text("Select Picture")
                                    .foregroundColor(.black)
                            }
                        })
                    }
                    
                    
                    //                Picker("Choose Option", selection: Binding<SelectionOption>(
                    //                    set: { newValue in
                    //                        if newValue == .photo {
                    //                            showImageSourceActionSheet = true
                    //                        } else {
                    //                            itemImage = nil
                    //                        }
                    //                    }
                    //                )) {
                    //                    Text("Choose Photo").tag(SelectionOption.photo)
                    //                    Text("Choose Color").tag(SelectionOption.color)
                    //                }
                    //                .pickerStyle(SegmentedPickerStyle())
                    //                .padding()
                    
                    //                    if !isPhotoSelected {
                    //                        ColorPicker("Pick a Color", selection:$itemColor)
                    //                            .frame(width: 330)
                    //                            .foregroundColor(.black)
                    //                    }
                    
                    if isPhotoSelected {
                        if itemImage == nil {
                            Button(action: {
                                showImageSourceActionSheet = true
                            }) {
                                Text("Add Picture")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                    }
                    
                    Spacer()
                    RoundedButton(title: "Add Item", action: {
                        let newItem: Item
                        if isPhotoSelected {
                            newItem = Item(id: UUID(), name: itemNameInput, color: .clear, image: itemImage?.fixOrientation())
                        } else {
                            newItem = Item(id: UUID(), name: itemNameInput, color: itemColor, image: nil)
                        }
                        items.append(newItem)
                        completion(itemName)
                        itemNameInput = "" // Reset itemNameInput to empty string
                        
                        isShowing = false
                        itemImage = nil // Reset itemImage to nil
                    })
                }
                .frame(maxWidth: .infinity)
                .background(Color(.white))
                .navigationTitle(itemNameInput)
                .navigationBarTitleDisplayMode(.inline)
                .actionSheet(isPresented: $showImageSourceActionSheet) {
                    ActionSheet(
                        title: Text("Choose Photo Source"),
                        buttons: [
                            .default(Text("Camera"), action: {
                                showImagePicker = true
                                sourceType = .camera
                            }),
                            .default(Text("Photo Library"), action: {
                                showImagePicker = true
                                sourceType = .photoLibrary
                            }),
                            .cancel()
                        ]
                    )
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: $itemImage, sourceType: $sourceType)
                }
                //.navigationBarTitle("Tambah Item")
                .navigationBarItems(trailing: Button(action: {
                    isShowing = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color("Button"))
                })
                    
//                .offset(x: 0, y: 300)
            }
            
        }
    }
    
    var isPhotoSelected: Bool {
        return itemImage != nil
    }
    
    enum SelectionOption {
        case photo, color
    }
}

extension UIImage {
    func fixOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return normalizedImage ?? self
    }
}

struct Item: Identifiable, Codable {
    var id: UUID
    var name: String
    var color: Color = Color("Text")
    var imageData: Data?
    
    var image: UIImage? {
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    init(id: UUID = UUID(), name: String, color: Color, image: UIImage?) {
        self.id = id
        self.name = name
        self.color = color
        self.imageData = image?.pngData()
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, color, imageData
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        imageData = try container.decode(Data?.self, forKey: .imageData)
        if let colorData = try container.decode(Data?.self, forKey: .color),
           let unarchivedColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
            color = Color(unarchivedColor)
        } else {
            color = Color.gray
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(imageData, forKey: .imageData)
        if let colorData = try? NSKeyedArchiver.archivedData(withRootObject: UIColor(color), requiringSecureCoding: false) {
            try container.encode(colorData, forKey: .color)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var sourceType: UIImagePickerController.SourceType
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        // Empty implementation
    }
}

struct RectangleView: View {
    var item: Item
    @Binding var items: [Item]
    
    var body: some View {
        ZStack (alignment: .center){
            if item.image != nil {
                Image(uiImage: item.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 150, maxHeight: 150)
                    .overlay(RoundedRectangle(cornerRadius: 15) .stroke(Color.gray, lineWidth: 5))
                    .background(Color("Text"))
                    .cornerRadius(15)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 150, height: 150)
                    .foregroundColor(item.color)
            }
                VStack  {
                    HStack {
                        Spacer()
                        Button(action: {
                            removeItem(item)
                        }) {
                            ZStack{
                                Circle()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                    .frame(width: 25, height: 25)
                                    .shadow(radius: 4, x: 0, y: 2)
                            }
                        }
                        .padding(5)
                    }
                    Spacer()
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 150, height: 42)
                            .foregroundColor(Color("Button"))
                        Text(item.name)
                            .font(.body)
                            .frame(width: 130, height: 32)
                            .foregroundColor(.white)
                    }
//                    .padding(.top, -50)
                }
        }
        .frame(width: 175, height: 175)
//        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 4, x:0 ,y: 2)
    }
    
    func removeItem(_ item: Item) {
        items.removeAll { $0.id == item.id }
    }
}

