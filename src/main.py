import sys
from pxr import Usd, Tf, Sdf

"""
Just for a curious performance test. While using SdfChangeBlock changes should be performed directly
via the Sdf API without talking to downstream libraries like UsdStage below in this function.
"""
def UsdCreateOverridePrims(stage, vec):
    count = 0
    with Sdf.ChangeBlock():
        for path in vec:
            stage.OverridePrim(path.AppendElementString("group_" + str(count)))
            count +=1

# Creating OverridePrim via Sdf API
def SdfCreateOverridePrims(layer, vec):
    count = 0
    with Sdf.ChangeBlock():
        for path in vec:
            Sdf.JustCreatePrimInLayer(layer, path.AppendElementString("group_" + str(count)))
            count +=1

def main():
    if len(sys.argv) < 3:
        print ("Usage: {} <Input USD file> <Output Usd File>\n".format(sys.argv[0]))
        return 1
    stage = Usd.Stage.Open(sys.argv[1])
    if not stage:
        print("Failed to open USD file: {}\n".format(sys.argv[1]))
        return 1
    
    watch = Tf.Stopwatch() 
    # Run
    watch.Start()
    def_prim = stage.GetDefaultPrim()
    if not def_prim.IsValid():
        print("Default prim isn't defined\n")
        return 1
    def_prim_path = def_prim.GetPath()
    rootLayerPtr = stage.GetRootLayer()
    vec = Sdf.PathArray([def_prim_path.AppendElementString("test")]*250000)
    
    SdfCreateOverridePrims(rootLayerPtr, vec)
    
    watch.Stop()
    print("Run time : {} s\n".format(watch.seconds))
  
    filename = sys.argv[2]
    is_exported = rootLayerPtr.Export(filename)
    print("Stage is exported: {}\n".format(str(is_exported)))
    return 0

if __name__ == "__main__":
    main()