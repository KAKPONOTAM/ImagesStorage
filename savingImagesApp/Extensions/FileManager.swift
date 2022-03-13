import Foundation
import UIKit

extension FileManager {
    static func saveImage(_ image: UIImage) -> String? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first // получили имя папки, куда будем писать файл
        let fileName = UUID().uuidString // создали уникальное имя файла
        
        guard let fileURL = documentsDirectory?.appendingPathComponent(fileName), // добавили имя файла к имени папки
              let imageData = image.jpegData(compressionQuality: 1) else { return nil } // превратили image в 0100101011010110101 (Data)
        
        if FileManager.default.fileExists(atPath: fileURL.path) { // если вдруг уже есть такой файл
            do {
                try FileManager.default.removeItem(atPath: fileURL.path) // пытаемся его удалить
            } catch { // или ловим ошибку
                print(error.localizedDescription) // и распечатываем ее
                return nil // так как все пошло не так - сохранение не удалось, уходим
            }
        }
        
        do {
            try imageData.write(to: fileURL) // пытаемся сохранить 001010101 в файл по выбранному имени (все хорошо)
            return fileName // сохранение удалось - возвращаем имя файла для дальнейшей работы
        } catch { // или ловим ошибку
            print(error.localizedDescription) // и распечатываем ее
            return nil // так как все пошло не так - сохранение не удалось, уходим
        }
    }
    
    static func loadImage(fileName: String) -> UIImage? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil } // получили имя папки, где должен лежать файл
        let fileURL = documentsDirectory.appendingPathComponent(fileName) // добавили имя файла к имени папки
        let image = UIImage(contentsOfFile: fileURL.path) // прочитали файл, превратив его в UIImage
        return image // вернули картинку
    }
}

