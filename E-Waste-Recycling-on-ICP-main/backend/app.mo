import Time "mo:base/Time";
import Array "mo:base/Array";
import Principal "mo:base/Principal";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Option "mo:base/Option";
import Iter "mo:base/Iter";


actor {

  type DeviceStatus = {
    #Manufactured;
    #Sold;
    #InUse;
    #Recycled;
  };

  type Device = {
    id : Text;
    model : Text;
    owner : Principal;
    status : DeviceStatus;
    timestamp : Time.Time;
  };

  stable var devices : [Device] = [];

  public shared(msg) func registerDevice(id : Text, model : Text) : async Text {
    let device = {
      id = id;
      model = model;
      owner = msg.caller;
      status = #Manufactured;
      timestamp = Time.now();
    };
    devices := Array.append<Device>(devices, [device]);
    "Device registered successfully!"
  };

  public func updateDeviceStatus(id : Text, newStatus : DeviceStatus) : async Text {
    devices := Array.map<Device, Device>(devices, func(d) {
      if (d.id == id) {
        {
          id = d.id;
          model = d.model;
          owner = d.owner;
          status = newStatus;
          timestamp = Time.now();
        }
      } else {
        d
      }
    });
    "Device status updated."
  };

  public func getAllDevices() : async [Device] {
    devices
  };

  public func getDevicesByOwner(user: Principal) : async [Device] {
    Array.filter<Device>(devices, func(d) { d.owner == user })
  };
}
