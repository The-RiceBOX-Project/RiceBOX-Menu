using Godot;
using System;
using System.IO.Ports;

public partial class arduino : Node
{
	[Signal]
	public delegate void DataRecievedEventHandler(string myString);

	[Signal]
	public delegate void I_Button_UpEventHandler();

	[Signal]
	public delegate void I_Button_DownEventHandler();

	[Signal]
	public delegate void M_Button_UpEventHandler();

	[Signal]
	public delegate void M_Button_DownEventHandler();

	[Signal]
	public delegate void X_Button_UpEventHandler();

	[Signal]
	public delegate void X_Button_DownEventHandler();

	[Signal]
	public delegate void C_Button_UpEventHandler();

	[Signal]
	public delegate void C_Button_DownEventHandler();

	[Signal]
	public delegate void Joystick_Button_UpEventHandler();

	[Signal]
	public delegate void Joystick_Button_DownEventHandler();

	[Signal]
	public delegate void Menu_Button_UpEventHandler();

	[Signal]
	public delegate void Menu_Button_DownEventHandler();

	[Signal]
	public delegate void JoystickMovedEventHandler(float h, float v);
	
	[Export]
	public int BaudRate { get; set; } = 9600;
	[Export]
	public string PortName { get; set; } = "COM4";

	[Export]
	public Key I_button_key;

	[Export]
	public Key M_button_key;

	[Export]
	public Key X_button_key;

	[Export]
	public Key C_button_key;

	[Export]
	public Key Joystick_button_key;

	[Export]
	public Key Menu_button_key;
	
	SerialPort serialPort;
	
	public override void _Ready()
	{
		serialPort = new SerialPort
		{
			PortName = PortName,
			BaudRate = BaudRate
		};
		serialPort.DtrEnable = true;
		
		if (IsDeviceConnected(serialPort))
		{
			openPort(serialPort);
		}
		else
		{
			GD.PrintErr($"No device detected on port {PortName}.");
		}
	}
	
	
	public override void _Process(double delta)
	{
		if (serialPort == null || !serialPort.IsOpen)
		{
			if (IsDeviceConnected(serialPort))
			{
				openPort(serialPort);
			}
			return;
		}
		
		try
		{
			string message = serialPort.ReadExisting();
			if (!string.IsNullOrEmpty(message))
			{
				EmitSignal(SignalName.DataRecieved, message);

				string[] message_splited = message.Split(" ");

				float joystick_v = message_splited[0].ToFloat();
				float joystick_h = message_splited[1].ToFloat();

				int joystickButton = message_splited[2].ToInt();
				int IButton = message_splited[3].ToInt();
				int MButton = message_splited[4].ToInt();
				int XButton = message_splited[5].ToInt();
				int CButton = message_splited[6].ToInt();
				int MenuButton = message_splited[7].ToInt();

				EmitSignal(SignalName.JoystickMoved, joystick_h, joystick_v);

				if(joystickButton == 1){
					EmitSignal(SignalName.Joystick_Button_Down);
				}else{
					EmitSignal(SignalName.Joystick_Button_Up);
				}

				if(IButton == 1){
					EmitSignal(SignalName.I_Button_Down);
				}else{
					EmitSignal(SignalName.I_Button_Up);
				}

				if(MButton == 1){
					EmitSignal(SignalName.M_Button_Down);
				}else{
					EmitSignal(SignalName.M_Button_Up);
				}

				if(XButton == 1){
					EmitSignal(SignalName.X_Button_Down);
				}else{
					EmitSignal(SignalName.X_Button_Up);
				}

				if(CButton == 1){
					EmitSignal(SignalName.C_Button_Down);
				}else{
					EmitSignal(SignalName.C_Button_Up);
				}

				if(MenuButton == 1){
					EmitSignal(SignalName.Menu_Button_Down);
				}else{
					EmitSignal(SignalName.Menu_Button_Up);
				}


				if(Joystick_button_key != Key.None){
					if(joystickButton == 1){
						InputEventKey e = new InputEventKey();
						e.Keycode = Joystick_button_key;
						e.Pressed = true;
						Input.ParseInputEvent(e);
					}else{
						InputEventKey e = new InputEventKey();
						e.Keycode = Joystick_button_key;
						e.Pressed = false;
						Input.ParseInputEvent(e);
					}
				}

				if(I_button_key != Key.None){
					if(IButton == 1){
						InputEventKey e = new InputEventKey();
						e.Keycode = I_button_key;
						e.Pressed = true;
						Input.ParseInputEvent(e);
					}else{
						InputEventKey e = new InputEventKey();
						e.Keycode = I_button_key;
						e.Pressed = false;
						Input.ParseInputEvent(e);
					}
				}

				if(M_button_key != Key.None){
					if(MButton == 1){
						InputEventKey e = new InputEventKey();
						e.Keycode = M_button_key;
						e.Pressed = true;
						Input.ParseInputEvent(e);
					}else{
						InputEventKey e = new InputEventKey();
						e.Keycode = M_button_key;
						e.Pressed = false;
						Input.ParseInputEvent(e);
					}
				}

				if(X_button_key != Key.None){
					if(XButton == 1){
						InputEventKey e = new InputEventKey();
						e.Keycode = X_button_key;
						e.Pressed = true;
						Input.ParseInputEvent(e);
					}else{
						InputEventKey e = new InputEventKey();
						e.Keycode = X_button_key;
						e.Pressed = false;
						Input.ParseInputEvent(e);
					}
				}

				if(C_button_key != Key.None){
					if(CButton == 1){
						InputEventKey e = new InputEventKey();
						e.Keycode = C_button_key;
						e.Pressed = true;
						Input.ParseInputEvent(e);
					}else{
						InputEventKey e = new InputEventKey();
						e.Keycode = C_button_key;
						e.Pressed = false;
						Input.ParseInputEvent(e);
					}
				}

				if(Menu_button_key != Key.None){
					if(MenuButton == 1){
						InputEventKey e = new InputEventKey();
						e.Keycode = Menu_button_key;
						e.Pressed = true;
						Input.ParseInputEvent(e);
					}else{
						InputEventKey e = new InputEventKey();
						e.Keycode = Menu_button_key;
						e.Pressed = false;
						Input.ParseInputEvent(e);
					}
				}
				

			}
		}
		catch (Exception ex)
		{
			GD.PrintErr($"Error while reading from serial port: {ex.Message}");
			// Close the port to reset the state
			serialPort?.Close();
		}
	}
	
	
	public override void _ExitTree()
	{
		if (serialPort != null && serialPort.IsOpen)
		{
			serialPort.Close();
		}
		serialPort?.Dispose();
		GD.Print("Serial port closed.");
	}
	
	
	
	private void openPort(SerialPort port)
	{
		try
		{
			port.Open();
			GD.Print($"Port {port.PortName} opened successfully.");
		}
		catch (Exception ex)
		{
			GD.PrintErr($"Failed to open port {port.PortName}: {ex.Message}");
		}
	}
	
	private bool IsDeviceConnected(SerialPort port)
	{
		try
		{
			if (!port.IsOpen)
			{
				port.Open();
				port.Close();
			}
			return true;
		}
		catch
		{
			return false;
		}
	}
}
