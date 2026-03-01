// import "dart:ffi";
// import "package:ffi/ffi.dart";
// import "package:win32/win32.dart";
//
//
// final _kernel32 = DynamicLibrary.open('kernel32.dll');
// final _advapi32 = DynamicLibrary.open('advapi32.dll');
//
// const LMEM_FIXED = 0x0000;
// const LMEM_ZEROINIT = 0x0040;
// const LPTR = LMEM_FIXED | LMEM_ZEROINIT;
// const SECURITY_DESCRIPTOR_MIN_LENGTH = 20;
// const SECURITY_DESCRIPTOR_REVISION = 1;
//
// // LocalAlloc: HLOCAL LocalAlloc(UINT uFlags, SIZE_T uBytes);
// // 注意：SIZE_T 在 x64 是 64 位，x86 是 32 位，对应 IntPtr
// final LocalAlloc = _kernel32.lookupFunction<
//     Pointer<Void> Function(Uint32 uFlags, IntPtr uBytes),
//     Pointer<Void> Function(int uFlags, int uBytes)
// >('LocalAlloc');
//
// // LocalFree: HLOCAL LocalFree(HLOCAL hMem);
// // final LocalFree = _kernel32.lookupFunction<
// //     Pointer<Void> Function(Pointer<Void> hMem),
// //     Pointer<Void> Function(Pointer<Void> hMem)
// // >('LocalFree');
//
// // InitializeSecurityDescriptor: BOOL InitializeSecurityDescriptor(
// //   PSECURITY_DESCRIPTOR pSecurityDescriptor, DWORD dwRevision);
// final InitializeSecurityDescriptor = _advapi32.lookupFunction<
//     Int32 Function(Pointer<Void> pSecurityDescriptor, Uint32 dwRevision),
//     int Function(Pointer<Void> pSecurityDescriptor, int dwRevision)
// >('InitializeSecurityDescriptor');
//
// // SetSecurityDescriptorDacl: BOOL SetSecurityDescriptorDacl(
// //   PSECURITY_DESCRIPTOR pSecurityDescriptor,
// //   BOOL bDaclPresent,
// //   PACL pDacl,
// //   BOOL bDaclDefaulted);
// final SetSecurityDescriptorDacl = _advapi32.lookupFunction<
//     Int32 Function(
//         Pointer<Void> pSecurityDescriptor,
//         Int32 bDaclPresent,
//         Pointer<Void> pDacl,
//         Int32 bDaclDefaulted
//         ),
//     int Function(
//         Pointer<Void> pSecurityDescriptor,
//         int bDaclPresent,
//         Pointer<Void> pDacl,
//         int bDaclDefaulted
//         )
// >('SetSecurityDescriptorDacl');
//
// final CreateMutexW = _kernel32.lookupFunction<
//   IntPtr Function(Pointer<SECURITY_ATTRIBUTES> lpMutexAttributes, Int32 bInitialOwner, Pointer<Utf16> lpName),
//   int Function(Pointer<SECURITY_ATTRIBUTES> lpMutexAttributes, int bInitialOwner, Pointer<Utf16> lpName)
// >("CreateMutexW");